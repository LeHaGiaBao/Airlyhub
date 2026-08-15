//
//  TourService.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import FirebaseFirestore

/// Reads over the top-level `tours` collection.
///
/// Unlike `CardService` there is no ownership filter to apply: the catalog is the
/// same for everybody and the rules allow any signed-in read. What replaces that
/// safeguard is the `limit` on every query — without it a single search would bill
/// the whole collection against the free plan's daily read quota.
///
/// Swap for `MockTourRepository` by changing the one line in the builder; both
/// conform to `TourRepositoryProtocol` and sort results identically.
final class TourService: TourRepositoryProtocol {
    static let shared = TourService()

    /// Matches `MockTourRepository.pageSize` so "Show more" behaves the same
    /// against either source.
    static let pageSize = 3

    /// How many documents to pull per round trip while filling a page.
    ///
    /// Larger than `pageSize` because the passenger filter runs client-side: a
    /// fetch of exactly three can come back with one match and leave the screen
    /// showing a short page while plenty of results remain further down.
    private static let fetchLimit = 12

    /// Bounds the fill loop. Without it a query whose matches are all clustered
    /// past thousands of non-matching documents would page through the entire
    /// collection on one tap.
    private static let maxFetchRounds = 5

    private static let popularTag = "popular"

    private let db = Firestore.firestore()

    private init() {}

    private var toursCollection: CollectionReference {
        db.collection(FirestoreCollection.tours)
    }

    // MARK: - TourRepositoryProtocol

    func search(_ query: TourQuery,
                after cursor: TourCursor?,
                completion: @escaping (Result<TourPage, Error>) -> Void) {
        fill(
            query: query,
            after: (cursor as? SnapshotCursor)?.snapshot,
            collected: [],
            round: 0,
            completion: completion
        )
    }

    func popular(type: TourType,
                 limit: Int,
                 completion: @escaping (Result<[TourModel], Error>) -> Void) {
        baseQuery(type: type)
            .whereField("tags", arrayContains: Self.popularTag)
            .order(by: "rating", descending: true)
            .limit(to: limit)
            .getDocuments { snapshot, error in
                if let error {
                    DispatchQueue.main.async { completion(.failure(error)) }
                    return
                }

                let items = Self.decode(snapshot?.documents ?? []).map(\.model)
                DispatchQueue.main.async { completion(.success(items)) }
            }
    }

    // MARK: - Querying

    /// The equality filters every search shares. `rating` ordering is applied by
    /// the caller so `popular` and `search` can't drift apart.
    private func baseQuery(type: TourType) -> Query {
        toursCollection
            .whereField("type", isEqualTo: type.rawValue)
            .whereField("isActive", isEqualTo: true)
    }

    /// Only equality filters go to the server. `passengers` needs `>=`, and
    /// Firestore allows a range filter on a single field whose `orderBy` must come
    /// first — using it here would forbid sorting by rating, so that one condition
    /// is applied in `matches(_:)` instead.
    private func searchQuery(_ query: TourQuery) -> Query {
        var result = baseQuery(type: query.type)

        if let origin = query.originSlug {
            result = result.whereField("originSlug", isEqualTo: origin)
        }
        if let destination = query.destinationSlug {
            result = result.whereField("destinationSlug", isEqualTo: destination)
        }

        return result.order(by: "rating", descending: true)
    }

    /// Fetches until a full page of *matching* records is in hand.
    ///
    /// The recursion is what makes the client-side passenger filter safe to page
    /// through: each round asks for the next `fetchLimit` documents and keeps the
    /// ones that match, stopping as soon as there are enough or the collection runs
    /// out. Returning a short page instead would make "Show more" look like it had
    /// reached the end when it had not.
    private func fill(query: TourQuery,
                      after snapshot: DocumentSnapshot?,
                      collected: [Match],
                      round: Int,
                      completion: @escaping (Result<TourPage, Error>) -> Void) {
        var request = searchQuery(query).limit(to: Self.fetchLimit)
        if let snapshot {
            request = request.start(afterDocument: snapshot)
        }

        request.getDocuments { [weak self] snapshot, error in
            guard let self else { return }

            if let error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }

            let documents = snapshot?.documents ?? []
            let matches = collected + Self.decode(documents).filter { $0.model.matches(query) }
            // Fewer documents than asked for means the query is exhausted; there is
            // nothing left to fetch regardless of how many matched.
            let exhausted = documents.count < Self.fetchLimit

            let shouldStop = exhausted
                || matches.count > Self.pageSize
                || round + 1 >= Self.maxFetchRounds

            guard shouldStop else {
                self.fill(
                    query: query,
                    after: documents.last,
                    collected: matches,
                    round: round + 1,
                    completion: completion
                )
                return
            }

            DispatchQueue.main.async {
                completion(.success(Self.page(from: matches, exhausted: exhausted)))
            }
        }
    }

    /// Trims the collected matches to one page and points the cursor at the last
    /// record actually returned — not the last document read, which would skip
    /// over the over-fetched matches on the following page.
    private static func page(from matches: [Match], exhausted: Bool) -> TourPage {
        let visible = Array(matches.prefix(pageSize))
        let hasMore = matches.count > visible.count || !exhausted

        return TourPage(
            items: visible.map(\.model),
            cursor: hasMore
                ? visible.last.map { SnapshotCursor(snapshot: $0.snapshot) }
                : nil
        )
    }

    /// A single malformed document shouldn't blank the list — same stance as
    /// `CardService.fetchCards`.
    private static func decode(_ documents: [QueryDocumentSnapshot]) -> [Match] {
        documents.compactMap { document in
            // Documents are created with auto-ids, so the key is the only place the
            // identity lives — same as `CardService`.
            guard let dto = try? document.data(as: TourDTO.self),
                  let model = dto.toDomain(id: document.documentID) else { return nil }
            return Match(model: model, snapshot: document)
        }
    }

    /// Pairs a decoded record with the snapshot it came from, so pagination can
    /// resume from a record the client kept rather than from a document it discarded.
    private struct Match {
        let model: TourModel
        let snapshot: DocumentSnapshot
    }

    /// Firestore resumes a query from a document, not an offset — hence an opaque
    /// cursor the caller hands straight back.
    private struct SnapshotCursor: TourCursor {
        let snapshot: DocumentSnapshot
    }
}

// MARK: - Client-side refinement
private extension TourModel {
    /// The part of `TourQuery` the server cannot answer. Kept in step with
    /// `MockTourRepository`'s filter so the two repositories agree on what matches.
    func matches(_ query: TourQuery) -> Bool {
        if let minimum = query.minimumPassengers, passengers < minimum {
            return false
        }

        // `date` is not filtered on: the catalog carries no schedule. Availability
        // belongs on a separate `departures` collection once real bookings exist.
        return true
    }
}

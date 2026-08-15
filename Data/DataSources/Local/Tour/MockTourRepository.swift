//
//  MockTourRepository.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Serves the catalog from `tours.seed.json` in the app bundle.
///
/// The same file is what gets uploaded to Firestore, so the mock and the server
/// cannot drift apart in shape. Filtering happens in memory here; the Firestore
/// implementation will push the equality filters (`type`, `originSlug`,
/// `destinationSlug`) into the query and keep only the passenger refinement
/// client-side, because Firestore allows a range filter on just one field and
/// spending it on `passengers` would forbid ordering by rating.
///
/// Completions hop to the main queue after a short delay, so the screen exercises
/// its real loading state instead of rendering fully-formed on the first frame.
final class MockTourRepository: TourRepositoryProtocol {
    /// Matches the "Show more" rhythm in the design: three cards, then a button.
    static let pageSize = 3

    private let resourceName: String
    private let latency: TimeInterval

    /// Parsed once — the file is read from disk on first use, not per search.
    private lazy var records: [TourModel] = loadRecords()

    init(resourceName: String = "tours.seed", latency: TimeInterval = 0.4) {
        self.resourceName = resourceName
        self.latency = latency
    }

    // MARK: - TourRepositoryProtocol

    func search(_ query: TourQuery,
                after cursor: TourCursor?,
                completion: @escaping (Result<TourPage, Error>) -> Void) {
        let offset = (cursor as? OffsetCursor)?.offset ?? 0
        // Sorted the way `TourService` sorts, so paging through either repository
        // walks the records in one order.
        //
        // Ties fall back to id *descending*, which looks arbitrary but is not:
        // Firestore appends an implicit `__name__` tiebreak in the same direction
        // as the last ordered field, and that field is `rating` descending. Sorting
        // ascending here would let the two sources disagree on the order of
        // equal-rated records, and a record could then show up twice or not at all
        // as the cursor advances.
        let matches = records
            .filter { $0.matches(query) }
            .sorted(by: Self.byRatingThenID)

        // `prefix`/`dropFirst` clamp on their own, so an offset past the end yields
        // an empty page rather than trapping.
        let slice = Array(matches.dropFirst(offset).prefix(Self.pageSize))
        let next = offset + slice.count
        let page = TourPage(
            items: slice,
            cursor: next < matches.count ? OffsetCursor(offset: next) : nil
        )

        respond(.success(page), completion: completion)
    }

    func popular(type: TourType,
                 limit: Int,
                 completion: @escaping (Result<[TourModel], Error>) -> Void) {
        // Same ordering as `search`, and for the same reason — `records` comes out
        // of a dictionary, so without the id tiebreak equally-rated tours would
        // swap places between launches.
        let items = records
            .filter { $0.type == type && $0.tags.contains(Self.popularTag) }
            .sorted(by: Self.byRatingThenID)
            .prefix(limit)

        respond(.success(Array(items)), completion: completion)
    }

    // MARK: - Helpers

    private static let popularTag = "popular"

    /// The order `TourService` gets from Firestore, reproduced locally.
    ///
    /// Ties fall back to id *descending*, which looks arbitrary but is not:
    /// Firestore appends an implicit `__name__` tiebreak in the same direction as
    /// the last ordered field, and that field is `rating` descending. Without a
    /// tiebreak at all, paging could show a record twice or skip it as the cursor
    /// advances.
    private static func byRatingThenID(_ lhs: TourModel, _ rhs: TourModel) -> Bool {
        let left: Double = lhs.rating ?? 0
        let right: Double = rhs.rating ?? 0
        return left == right ? lhs.id > rhs.id : left > right
    }

    /// Opaque cursor for this implementation: an index into the filtered array.
    /// Firestore's equivalent will wrap a `DocumentSnapshot` instead, which is why
    /// callers must pass the value back rather than derive the next offset.
    private struct OffsetCursor: TourCursor {
        let offset: Int
    }

    private func respond<T>(_ result: Result<T, Error>,
                            completion: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + latency) {
            completion(result)
        }
    }

    private func loadRecords() -> [TourModel] {
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            assertionFailure("\(resourceName).json is missing from the bundle")
            return []
        }

        do {
            // Keyed by id, not an array: the object key plays the part Firestore's
            // `documentID` plays, so the file mirrors the collection one-for-one.
            //
            // A single malformed record shouldn't blank the whole catalog — same
            // stance as `CardService.fetchCards`.
            return try JSONDecoder()
                .decode([String: TourDTO].self, from: data)
                .filter { $0.value.isActive ?? true }
                .compactMap { $0.value.toDomain(id: $0.key) }
        } catch {
            assertionFailure("\(resourceName).json failed to decode: \(error)")
            return []
        }
    }
}

// MARK: - Filtering
private extension TourModel {
    /// Mirrors what the Firestore query plus its client-side refinement will do,
    /// so swapping repositories doesn't quietly change which records match.
    func matches(_ query: TourQuery) -> Bool {
        guard type == query.type else { return false }

        if let origin = query.originSlug, originSlug != origin {
            return false
        }
        if let destination = query.destinationSlug, destinationSlug != destination {
            return false
        }
        if let minimum = query.minimumPassengers, passengers < minimum {
            return false
        }

        // `date` is not filtered on: the catalog has no schedule yet. Availability
        // belongs on a separate `departures` collection once real bookings exist.
        return true
    }
}

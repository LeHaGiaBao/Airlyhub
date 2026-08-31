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
final class TourService: TourRepositoryProtocol {
    static let shared = TourService()

    static let pageSize = 3

    private static let fetchLimit = 12

    private static let maxFetchRounds = 5

    private static let popularTag = "popular"

    private let db = Firestore.firestore()

    private init() {}

    private var toursCollection: CollectionReference {
        db.collection(FirestoreCollection.tours)
    }

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

    func detail(id: String,
                completion: @escaping (Result<TourDetailModel?, Error>) -> Void) {
        toursCollection.document(id).getDocument { snapshot, error in
            if let error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }

            guard let snapshot, snapshot.exists,
                  let dto = try? snapshot.data(as: TourDTO.self) else {
                DispatchQueue.main.async { completion(.success(nil)) }
                return
            }

            DispatchQueue.main.async {
                completion(.success(dto.toDetailDomain(id: snapshot.documentID)))
            }
        }
    }

    private func baseQuery(type: TourType) -> Query {
        toursCollection
            .whereField("type", isEqualTo: type.rawValue)
            .whereField("isActive", isEqualTo: true)
    }

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

    private static func decode(_ documents: [QueryDocumentSnapshot]) -> [Match] {
        documents.compactMap { document in
            guard let dto = try? document.data(as: TourDTO.self),
                  let model = dto.toDomain(id: document.documentID) else { return nil }
            return Match(model: model, snapshot: document)
        }
    }

    private struct Match {
        let model: TourModel
        let snapshot: DocumentSnapshot
    }

    private struct SnapshotCursor: TourCursor {
        let snapshot: DocumentSnapshot
    }
}

private extension TourModel {
    func matches(_ query: TourQuery) -> Bool {
        if let minimum = query.minimumPassengers, passengers < minimum {
            return false
        }

        return true
    }
}

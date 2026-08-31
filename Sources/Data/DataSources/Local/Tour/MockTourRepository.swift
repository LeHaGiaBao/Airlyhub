//
//  MockTourRepository.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Serves the catalog from `TourMockData`, compiled into the app.
final class MockTourRepository: TourRepositoryProtocol {
    static let pageSize = 3

    private static let popularTag = "popular"

    private let latency: TimeInterval

    init(latency: TimeInterval = 0.4) {
        self.latency = latency
    }

    func search(_ query: TourQuery,
                after cursor: TourCursor?,
                completion: @escaping (Result<TourPage, Error>) -> Void) {
        let offset = (cursor as? OffsetCursor)?.offset ?? 0
        let matches = records(ofType: query.type)

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
        let items = records(ofType: type)
            .filter { $0.tags.contains(Self.popularTag) }
            .prefix(limit)

        respond(.success(Array(items)), completion: completion)
    }

    func detail(id: String,
                completion: @escaping (Result<TourDetailModel?, Error>) -> Void) {
        respond(.success(TourMockData.detail(id: id)), completion: completion)
    }

    private func records(ofType type: TourType) -> [TourModel] {
        TourMockData.all
            .filter { $0.type == type }
            .sorted { lhs, rhs in
                let left: Double = lhs.rating ?? 0
                let right: Double = rhs.rating ?? 0
                return left == right ? lhs.id > rhs.id : left > right
            }
    }

    private struct OffsetCursor: TourCursor {
        let offset: Int
    }

    private func respond<T>(_ result: Result<T, Error>,
                            completion: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + latency) {
            completion(result)
        }
    }
}

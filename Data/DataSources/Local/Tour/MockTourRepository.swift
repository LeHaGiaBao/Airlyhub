//
//  MockTourRepository.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Serves the catalog from `TourMockData`, compiled into the app.
///
/// **Every search returns the same records.** Only `type` is honoured, because that
/// is what separates the two screens — Explore browses tours, Flights browses
/// point-to-point flights, and their cards differ. Origin, destination, date and
/// party size are all ignored, so any query fills the screen instead of leaving the
/// user staring at an empty result while building the UI.
///
/// That is a deliberate choice for a pet project, not an oversight: with fourteen
/// records and no backend, a search that filters honestly returns nothing most of
/// the time. `TourService` still filters for real; swapping the builder over is
/// what turns searching back on.
///
/// Completions hop to the main queue after a short delay, so the screen exercises
/// its real loading state instead of rendering fully-formed on the first frame.
final class MockTourRepository: TourRepositoryProtocol {
    /// Matches the "Show more" rhythm in the design: three cards, then a button.
    static let pageSize = 3

    private static let popularTag = "popular"

    private let latency: TimeInterval

    init(latency: TimeInterval = 0.4) {
        self.latency = latency
    }

    // MARK: - TourRepositoryProtocol

    func search(_ query: TourQuery,
                after cursor: TourCursor?,
                completion: @escaping (Result<TourPage, Error>) -> Void) {
        let offset = (cursor as? OffsetCursor)?.offset ?? 0
        let matches = records(ofType: query.type)

        // `dropFirst`/`prefix` clamp on their own, so an offset past the end yields
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
        let items = records(ofType: type)
            .filter { $0.tags.contains(Self.popularTag) }
            .prefix(limit)

        respond(.success(Array(items)), completion: completion)
    }

    // MARK: - Helpers

    /// Sorted by rating so the list looks ranked, with the id breaking ties to keep
    /// paging stable — without a tiebreak, two equally-rated records could swap
    /// places between pages and one would show twice while the other vanished.
    private func records(ofType type: TourType) -> [TourModel] {
        TourMockData.all
            .filter { $0.type == type }
            .sorted { lhs, rhs in
                let left: Double = lhs.rating ?? 0
                let right: Double = rhs.rating ?? 0
                return left == right ? lhs.id > rhs.id : left > right
            }
    }

    /// Opaque cursor for this implementation: an index into the sorted array.
    /// `TourService` wraps a `DocumentSnapshot` instead, which is why callers must
    /// pass the value back rather than derive the next offset themselves.
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

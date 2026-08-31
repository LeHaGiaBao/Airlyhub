//
//  MockFavoritesRepository.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Saved tours held in memory, seeded so the Favorites screen has something to show.
///
/// `AppContainer` holds one instance for the whole app: two screens showing hearts
/// must agree about which ones are filled, and a per-screen copy would let them
/// drift. State lives only for the session — persisting ids now would outlive the
/// mock catalog they point at, and `TourService` documents will carry auto-ids
/// that none of these match.
///
/// Completions hop to the main queue after a short delay, like `MockTourRepository`,
/// so the screen exercises its real loading state.
final class MockFavoritesRepository: FavoritesRepositoryProtocol {
    /// Two of each kind, matching the design's screenshots. Picked from
    /// `TourMockData` by id, so a record renamed there breaks the seed loudly —
    /// the screen renders empty — instead of quietly showing the wrong tour.
    private static let seed: Set<String> = [
        "tour_kronstadt_cessna172_selzo",
        "tour_kronstadt_cetus900",
        "flight_nsk_baikal_01",
        "flight_nsk_baikal_02"
    ]

    private var ids: Set<String>
    private let latency: TimeInterval

    init(seed: Set<String> = MockFavoritesRepository.seed, latency: TimeInterval = 0.3) {
        self.ids = seed
        self.latency = latency
    }

    // MARK: - FavoritesRepositoryProtocol

    func favorites(ofType type: TourType,
                   completion: @escaping (Result<[TourModel], Error>) -> Void) {
        // Filtering the catalog rather than mapping over `ids` keeps the result in
        // catalog order and drops any id whose record has gone away.
        let items = TourMockData.all.filter { $0.type == type && ids.contains($0.id) }

        DispatchQueue.main.asyncAfter(deadline: .now() + latency) {
            completion(.success(items))
        }
    }

    func isFavorite(tourID: String) -> Bool {
        ids.contains(tourID)
    }

    func setFavorite(_ isFavorite: Bool, tourID: String) {
        if isFavorite {
            ids.insert(tourID)
        } else {
            ids.remove(tourID)
        }
    }
}

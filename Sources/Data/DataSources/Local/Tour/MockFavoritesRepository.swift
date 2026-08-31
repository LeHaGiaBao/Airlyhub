//
//  MockFavoritesRepository.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Saved tours held in memory, seeded so the Favorites screen has something to show.
final class MockFavoritesRepository: FavoritesRepositoryProtocol {
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

    func favorites(ofType type: TourType,
                   completion: @escaping (Result<[TourModel], Error>) -> Void) {
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

//
//  TourDetailInteractor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

final class TourDetailInteractor: TourDetailInteractorProtocol {
    private let tourRepository: TourRepositoryProtocol
    private let favoritesRepository: FavoritesRepositoryProtocol

    init(tourRepository: TourRepositoryProtocol, favoritesRepository: FavoritesRepositoryProtocol) {
        self.tourRepository = tourRepository
        self.favoritesRepository = favoritesRepository
    }

    func loadDetail(id: String, completion: @escaping (Result<TourDetailModel?, Error>) -> Void) {
        tourRepository.detail(id: id, completion: completion)
    }

    func isFavorite(tourID: String) -> Bool {
        favoritesRepository.isFavorite(tourID: tourID)
    }

    func setFavorite(_ isFavorite: Bool, tourID: String) {
        favoritesRepository.setFavorite(isFavorite, tourID: tourID)
    }
}

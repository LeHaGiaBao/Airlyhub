//
//  FavoritesInteractor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import Foundation

final class FavoritesInteractor: FavoritesInteractorProtocol {
    private let repository: FavoritesRepositoryProtocol

    /// Injected, not looked up: `FavoritesBuilder` is the one place that decides
    /// whether the screen reads the in-memory mock or a real per-user store.
    init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    func favorites(ofType type: TourType,
                   completion: @escaping (Result<[TourModel], Error>) -> Void) {
        repository.favorites(ofType: type, completion: completion)
    }

    func setFavorite(_ isFavorite: Bool, tourID: String) {
        repository.setFavorite(isFavorite, tourID: tourID)
    }
}

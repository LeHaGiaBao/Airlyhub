//
//  FavoritesRepositoryProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// The user's saved tours, as the feature layer sees it.
protocol FavoritesRepositoryProtocol: AnyObject {
    func favorites(ofType type: TourType,
                   completion: @escaping (Result<[TourModel], Error>) -> Void)

    func isFavorite(tourID: String) -> Bool

    func setFavorite(_ isFavorite: Bool, tourID: String)
}

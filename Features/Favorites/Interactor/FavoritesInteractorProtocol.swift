//
//  FavoritesInteractorProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol FavoritesInteractorProtocol: AnyObject {
    func favorites(ofType type: TourType,
                   completion: @escaping (Result<[TourModel], Error>) -> Void)

    /// Fire-and-forget: the list drops the card straight away rather than waiting
    /// for the store to confirm.
    func setFavorite(_ isFavorite: Bool, tourID: String)
}

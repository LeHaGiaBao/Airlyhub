//
//  TourDetailInteractorProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol TourDetailInteractorProtocol: AnyObject {
    func loadDetail(id: String, completion: @escaping (Result<TourDetailModel?, Error>) -> Void)
    func isFavorite(tourID: String) -> Bool
    func setFavorite(_ isFavorite: Bool, tourID: String)
}

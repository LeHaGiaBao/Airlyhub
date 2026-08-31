//
//  TourRepositoryProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// The catalog, as the feature layer sees it.
protocol TourRepositoryProtocol: AnyObject {
    func search(_ query: TourQuery,
                after cursor: TourCursor?,
                completion: @escaping (Result<TourPage, Error>) -> Void)

    func popular(type: TourType,
                 limit: Int,
                 completion: @escaping (Result<[TourModel], Error>) -> Void)

    func detail(id: String,
                completion: @escaping (Result<TourDetailModel?, Error>) -> Void)
}

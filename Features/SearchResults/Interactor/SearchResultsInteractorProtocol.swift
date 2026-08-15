//
//  SearchResultsInteractorProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol SearchResultsInteractorProtocol: AnyObject {
    /// Pass `nil` for the first page; afterwards hand back the cursor from the
    /// previous `TourPage`.
    func search(_ query: TourQuery,
                after cursor: TourCursor?,
                completion: @escaping (Result<TourPage, Error>) -> Void)

    func popular(type: TourType,
                 completion: @escaping (Result<[TourModel], Error>) -> Void)
}

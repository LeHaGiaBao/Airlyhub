//
//  SearchResultsInteractor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

final class SearchResultsInteractor: SearchResultsInteractorProtocol {
    private static let popularLimit = 6

    private let repository: TourRepositoryProtocol

    init(repository: TourRepositoryProtocol) {
        self.repository = repository
    }

    func search(_ query: TourQuery,
                after cursor: TourCursor?,
                completion: @escaping (Result<TourPage, Error>) -> Void) {
        repository.search(query, after: cursor, completion: completion)
    }

    func popular(type: TourType,
                 completion: @escaping (Result<[TourModel], Error>) -> Void) {
        repository.popular(type: type, limit: Self.popularLimit, completion: completion)
    }
}

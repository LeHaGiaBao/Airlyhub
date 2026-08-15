//
//  SearchResultsInteractor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

final class SearchResultsInteractor: SearchResultsInteractorProtocol {
    /// How many tiles the "Popular" rail asks for. Enough to fill the visible width
    /// with one partly showing, which is what invites the horizontal scroll.
    private static let popularLimit = 6

    private let repository: TourRepositoryProtocol

    /// The repository arrives by injection rather than as a singleton lookup, which
    /// is the whole point of the protocol: `SearchResultsBuilder` decides whether
    /// this screen talks to the bundled seed file or to Firestore.
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

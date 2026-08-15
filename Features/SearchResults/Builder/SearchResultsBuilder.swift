//
//  SearchResultsBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class SearchResultsBuilder {
    /// The single place the catalog's source is chosen.
    ///
    /// Point this at `TourService.shared` once the `tours` collection is populated
    /// and its rules and indexes are deployed; nothing else in the feature changes,
    /// because both sides implement `TourRepositoryProtocol` and return results in
    /// the same order.
    private static func makeRepository() -> TourRepositoryProtocol {
        MockTourRepository()
    }

    func build(context: SearchResultsContext, nav: UINavigationController) -> UIViewController {
        let view = SearchResultsViewController()
        let interactor = SearchResultsInteractor(repository: Self.makeRepository())
        let router = SearchResultsRouter(nav: nav)
        let presenter = SearchResultsPresenter(view: view,
                                               interactor: interactor,
                                               router: router,
                                               context: context)

        view.presenter = presenter
        return view
    }
}

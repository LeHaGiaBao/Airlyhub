//
//  TourDetailBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class TourDetailBuilder {
    /// Mirrors `SearchResultsBuilder.makeRepository` / `FavoritesBuilder.makeRepository`
    /// — swap `MockTourRepository()` for `TourService.shared` once the `tours`
    /// collection is populated, and nothing else in the feature changes.
    private static func makeTourRepository() -> TourRepositoryProtocol {
        MockTourRepository()
    }

    /// Shared, not a fresh instance: a heart flipped here has to be reflected back
    /// on Favorites and on whichever search results list led here.
    private static func makeFavoritesRepository() -> FavoritesRepositoryProtocol {
        MockFavoritesRepository.shared
    }

    func build(tourID: String, nav: UINavigationController) -> UIViewController {
        let view = TourDetailViewController()
        let interactor = TourDetailInteractor(
            tourRepository: Self.makeTourRepository(),
            favoritesRepository: Self.makeFavoritesRepository()
        )
        let router = TourDetailRouter(nav: nav)
        let presenter = TourDetailPresenter(view: view,
                                            interactor: interactor,
                                            router: router,
                                            tourID: tourID)

        view.presenter = presenter
        return view
    }
}

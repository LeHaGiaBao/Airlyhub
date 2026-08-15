//
//  FavoritesBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import UIKit

final class FavoritesBuilder {
    /// The single place the saved set's source is chosen.
    ///
    /// `MockFavoritesRepository.shared` rather than a fresh instance: whatever else
    /// shows hearts has to read the same set, or the two screens disagree about
    /// what is saved. Swap this for a Firestore-backed store — nothing else in the
    /// feature changes, since both sides implement `FavoritesRepositoryProtocol`.
    private static func makeRepository() -> FavoritesRepositoryProtocol {
        MockFavoritesRepository.shared
    }

    func build(nav: UINavigationController) -> UIViewController {
        let view = FavoritesViewController()
        let interactor = FavoritesInteractor(repository: Self.makeRepository())
        let router = FavoritesRouter()
        let presenter = FavoritesPresenter(view: view,
                                           interactor: interactor,
                                           router: router)
        view.presenter = presenter
        router.viewController = view
        // The tab owns a stack like the others, so the tour detail screen has
        // somewhere to be pushed the moment it exists.
        nav.viewControllers = [view]
        return nav
    }
}

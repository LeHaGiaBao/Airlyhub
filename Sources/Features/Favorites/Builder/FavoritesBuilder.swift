//
//  FavoritesBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import UIKit

final class FavoritesBuilder {
    private let container: AppContainer

    init(container: AppContainer = .shared) {
        self.container = container
    }

    func build(nav: UINavigationController) -> UIViewController {
        let view = FavoritesViewController()
        let interactor = FavoritesInteractor(repository: container.favoritesRepository)
        let router = FavoritesRouter()
        let presenter = FavoritesPresenter(view: view,
                                           interactor: interactor,
                                           router: router)
        view.presenter = presenter
        router.viewController = view
        nav.viewControllers = [view]
        return nav
    }
}

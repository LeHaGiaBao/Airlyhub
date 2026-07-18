//
//  FavoritesBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import UIKit

final class FavoritesBuilder {
    func build(nav: UINavigationController) -> UIViewController {
        let view = FavoritesViewController()
        let interactor = FavoritesInteractor()
        let router = FavoritesRouter()
        let presenter = FavoritesPresenter(view: view,
                                           interactor: interactor,
                                           router: router)
        view.presenter = presenter
        router.viewController = view
        return view
    }
}

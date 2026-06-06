//
//  FavoritesBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import UIKit

final class FavoritesBuilder: FavoritesRouterProtocol {
    static func createModule(nav: UINavigationController) -> UIViewController {
        let view = FavoritesViewController()
        let interactor = FavoritesInteractor()
        let router = FavoritesBuilder()
        let presenter = FavoritesPresenter(
            view: view,
            interactor: interactor,
            router: router
        )

        view.presenter = presenter
        return view
    }
}

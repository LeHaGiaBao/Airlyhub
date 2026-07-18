//
//  ExploreBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import UIKit

final class ExploreBuilder {
    func build(nav: UINavigationController) -> UIViewController {
        let view = ExploreViewController()
        let interactor = ExploreInteractor()
        let router = ExploreRouter()
        let presenter = ExplorePresenter(view: view,
                                         interactor: interactor,
                                         router: router)

        view.presenter = presenter
        router.viewController = view
        return view
    }
}

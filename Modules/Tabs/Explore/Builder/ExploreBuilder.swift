//
//  ExploreBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import UIKit

final class ExploreBuilder: ExploreRouterProtocol {
    static func createModule(nav: UINavigationController) -> UIViewController {
        let view = ExploreViewController()
        let interactor = ExploreInteractor()
        let router = ExploreBuilder()
        let presenter = ExplorePresenter(
            view: view,
            interactor: interactor,
            router: router
        )

        view.presenter = presenter
        return view
    }
}

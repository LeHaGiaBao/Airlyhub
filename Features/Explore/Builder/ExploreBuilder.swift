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
        let router = ExploreRouter(nav: nav)
        let presenter = ExplorePresenter(view: view,
                                         interactor: interactor,
                                         router: router)

        view.presenter = presenter
        // Returns the navigation controller, not the screen: the tab has to own a
        // stack for the router to push the search results onto. `ProfilesBuilder`
        // does the same.
        nav.viewControllers = [view]
        return nav
    }
}

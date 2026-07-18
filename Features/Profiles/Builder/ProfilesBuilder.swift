//
//  ProfilesBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/03/2026.
//

import UIKit

final class ProfilesBuilder {
    func build(nav: UINavigationController) -> UIViewController {
        let interactor = ProfilesInteractor()
        let router = ProfilesRouter(nav: nav)
        let presenter = ProfilesPresenter(interactor: interactor,
                                          router: router)
        let view = ProfilesView(presenter: presenter)
        nav.viewControllers = [view]
        return nav
    }
}

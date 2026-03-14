//
//  ProfilesBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/03/2026.
//

import UIKit

final class ProfilesBuilder {
    static func build() -> UIViewController {
        let nav = UINavigationController()
        let interactor = ProfilesInteractor()
        let router = ProfilesRouter(nav: nav)
        let presenter = ProfilesPresenter(interactor: interactor,
                                          router: router)
        let view = ProfilesView(presenter: presenter)
        nav.viewControllers = [view]
        return nav
    }
}

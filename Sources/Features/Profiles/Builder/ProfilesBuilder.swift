//
//  ProfilesBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/03/2026.
//

import UIKit

final class ProfilesBuilder {
    private let container: AppContainer

    init(container: AppContainer = .shared) {
        self.container = container
    }

    func build(nav: UINavigationController) -> UIViewController {
        let interactor = ProfilesInteractor(auth: container.authRepository,
                                            users: container.userRepository,
                                            cards: container.cardRepository)
        let router = ProfilesRouter(nav: nav)
        let presenter = ProfilesPresenter(interactor: interactor,
                                          router: router)
        let view = ProfilesView(presenter: presenter)
        nav.viewControllers = [view]
        return nav
    }
}

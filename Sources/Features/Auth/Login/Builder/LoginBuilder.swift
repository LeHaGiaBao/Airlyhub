//
//  LoginBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/12/2025.
//

import UIKit

final class LoginBuilder {
    private let container: AppContainer

    init(container: AppContainer = .shared) {
        self.container = container
    }

    func build() -> UIViewController {
        let view = LoginViewController()
        let interactor = LoginInteractor(auth: container.authRepository)
        let router = LoginRouter()
        let presenter = LoginPresenter(view: view,
                                       interactor: interactor,
                                       router: router)
        view.presenter = presenter
        router.viewController = view
        return view
    }
}

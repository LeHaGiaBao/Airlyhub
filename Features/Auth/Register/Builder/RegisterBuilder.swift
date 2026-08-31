//
//  RegisterBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 21/03/2026.
//

import UIKit

final class RegisterBuilder {
    private let container: AppContainer

    init(container: AppContainer = .shared) {
        self.container = container
    }

    func build() -> UIViewController {
        let view = RegisterViewController()
        let interactor = RegisterInteractor(auth: container.authRepository,
                                            users: container.userRepository)
        let router = RegisterRouter()
        let presenter = RegisterPresenter(view: view,
                                          interactor: interactor,
                                          router: router)
        view.presenter = presenter
        router.viewController = view
        return view
    }
}

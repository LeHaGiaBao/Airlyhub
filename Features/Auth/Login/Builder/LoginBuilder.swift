//
//  LoginBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/12/2025.
//

import UIKit

enum LoginBuilder {
    static func createModule() -> UIViewController {
        let view = LoginViewController()
        let interactor = LoginInteractor()
        let router = LoginRouter()
        let presenter = LoginPresenter(
            view: view,
            interactor: interactor,
            router: router
        )
        view.presenter = presenter
        router.viewController = view
        return view
    }
}

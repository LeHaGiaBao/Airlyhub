//
//  LoginRouter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/12/2025.
//

import UIKit

final class LoginRouter: LoginRouterProtocol {
    weak var viewController: UIViewController?

    func navigateToHome() {
        guard let window = viewController?.view.window else { return }
        AppRouter.setRootToMainTab(in: window)
    }
    
    func navigateToRegister() {
        guard let window = viewController?.view.window else { return }
        AppRouter.setRootToRegister(in: window)
    }
}

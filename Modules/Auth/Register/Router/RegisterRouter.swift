//
//  RegisterRouter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 21/03/2026.
//

import UIKit

final class RegisterRouter: RegisterRouterProtocol {
    weak var viewController: UIViewController?

    func navigateToHome() {
        guard let window = viewController?.view.window else { return }
        AppRouter.setRootToMainTab(in: window)
    }
}

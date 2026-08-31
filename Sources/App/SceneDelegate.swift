//
//  SceneDelegate.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/12/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        if AppContainer.shared.authRepository.isLoggedIn() {
            window.rootViewController = AppRouter.createRootModule(nav: UINavigationController())
        } else {
            let register = LoginBuilder().build()
            window.rootViewController = UINavigationController(rootViewController: register)
        }
        window.makeKeyAndVisible()
        self.window = window
    }
}

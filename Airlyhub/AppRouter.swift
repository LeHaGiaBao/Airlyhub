//
//  AppRouter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/12/2025.
//

import UIKit

enum AppRouter {
    static func createRootModule() -> UIViewController {
        return LoginRouter.createModule()
    }
}

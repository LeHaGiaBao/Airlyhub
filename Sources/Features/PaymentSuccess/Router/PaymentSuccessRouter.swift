//
//  PaymentSuccessRouter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class PaymentSuccessRouter: PaymentSuccessRouterProtocol {
    private let nav: UINavigationController

    init(nav: UINavigationController) {
        self.nav = nav
    }

    func finish() {
        nav.popToRootViewController(animated: true)
    }
}

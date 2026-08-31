//
//  CheckoutRouter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class CheckoutRouter: CheckoutRouterProtocol {
    private let nav: UINavigationController

    init(nav: UINavigationController) {
        self.nav = nav
    }

    func dismiss() {
        nav.popViewController(animated: true)
    }

    func showPaymentSuccess() {
        let view = PaymentSuccessBuilder().build(nav: nav)
        view.hidesBottomBarWhenPushed = true
        nav.pushViewController(view, animated: true)
    }
}

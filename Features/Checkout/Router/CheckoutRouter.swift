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
        // The user should never swipe or tap back into a screen that already
        // charged them — hidden rather than removed so a fresh booking still shows
        // "Payment" if this flow starts again from the same tour.
        nav.pushViewController(view, animated: true)
    }
}

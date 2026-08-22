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

    /// Back to wherever the booking started (Explore, Flights or Favorites' own
    /// root) — never back into Checkout or the detail screen, both of which would
    /// let the user pay for the same tour a second time.
    func finish() {
        nav.popToRootViewController(animated: true)
    }
}

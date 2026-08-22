//
//  PaymentSuccessBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class PaymentSuccessBuilder {
    /// No view protocol, and the interactor is unused: the screen shows nothing
    /// dynamic — the booking was already written before this screen appears — so
    /// there is nothing for the presenter to tell the view or ask the interactor.
    func build(nav: UINavigationController) -> UIViewController {
        let view = PaymentSuccessViewController()
        let router = PaymentSuccessRouter(nav: nav)
        let presenter = PaymentSuccessPresenter(router: router)

        view.presenter = presenter
        return view
    }
}

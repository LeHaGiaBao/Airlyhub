//
//  PaymentSuccessPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

final class PaymentSuccessPresenter: PaymentSuccessPresenterProtocol {
    private let router: PaymentSuccessRouterProtocol

    init(router: PaymentSuccessRouterProtocol) {
        self.router = router
    }

    func didTapDone() {
        router.finish()
    }
}

//
//  CheckoutBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class CheckoutBuilder {
    private let container: AppContainer

    init(container: AppContainer = .shared) {
        self.container = container
    }

    func build(draft: BookingDraft, nav: UINavigationController) -> UIViewController {
        let view = CheckoutViewController()
        let interactor = CheckoutInteractor(
            bookingRepository: container.bookingRepository,
            cardsInteractor: MyCardsInteractor(cards: container.cardRepository,
                                               auth: container.authRepository)
        )
        let router = CheckoutRouter(nav: nav)
        let presenter = CheckoutPresenter(view: view,
                                          interactor: interactor,
                                          router: router,
                                          draft: draft)

        view.presenter = presenter
        return view
    }
}

//
//  CheckoutBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class CheckoutBuilder {
    /// The single place this screen's booking store is chosen. Swap back to
    /// `MockBookingRepository.shared` to work offline — nothing else changes,
    /// since both sides implement `BookingRepositoryProtocol`.
    private static func makeBookingRepository() -> BookingRepositoryProtocol {
        BookingService.shared
    }

    func build(draft: BookingDraft, nav: UINavigationController) -> UIViewController {
        let view = CheckoutViewController()
        let interactor = CheckoutInteractor(
            bookingRepository: Self.makeBookingRepository(),
            cardsInteractor: MyCardsInteractor()
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

//
//  MyTicketsBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import UIKit
import RxSwift

enum MyTicketsBuilderAction {
    case cancel
}

final class MyTicketsBuilder {
    /// Must stay pointed at the same store `CheckoutBuilder` writes to, or a
    /// booking just paid for would not appear in this list.
    private static func makeBookingRepository() -> BookingRepositoryProtocol {
        BookingService.shared
    }

    func build() -> (UIViewController, Observable<MyTicketsBuilderAction>) {
        let interactor = MyTicketsInteractor(bookingRepository: Self.makeBookingRepository())
        let router = MyTicketsRouter()
        let presenter = MyTicketsPresenter(interactor: interactor,
                                           router: router)
        let view = MyTicketsView(presenter: presenter)
        presenter.view = view
        router.viewController = view
        return (view, presenter.myTicketsBuilderAction)
    }
}

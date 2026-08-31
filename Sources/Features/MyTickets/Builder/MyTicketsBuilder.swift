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
    private let container: AppContainer

    init(container: AppContainer = .shared) {
        self.container = container
    }

    func build() -> (UIViewController, Observable<MyTicketsBuilderAction>) {
        let interactor = MyTicketsInteractor(bookingRepository: container.bookingRepository)
        let router = MyTicketsRouter()
        let presenter = MyTicketsPresenter(interactor: interactor,
                                           router: router)
        let view = MyTicketsView(presenter: presenter)
        presenter.view = view
        router.viewController = view
        return (view, presenter.myTicketsBuilderAction)
    }
}

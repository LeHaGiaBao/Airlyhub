//
//  MyCardsBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import UIKit
import RxSwift

enum MyCardsBuilderAction {
    case cancel
}

final class MyCardsBuilder {
    private let container: AppContainer

    init(container: AppContainer = .shared) {
        self.container = container
    }

    func build() -> (UIViewController, Observable<MyCardsBuilderAction>) {
        let interactor = MyCardsInteractor(cards: container.cardRepository,
                                           auth: container.authRepository)
        let router = MyCardsRouter()
        let presenter = MyCardsPresenter(interactor: interactor,
                                         router: router)
        let view = MyCardsView(presenter: presenter)
        presenter.view = view
        router.viewController = view
        return (view, presenter.myCardsBuilderAction)
    }
}

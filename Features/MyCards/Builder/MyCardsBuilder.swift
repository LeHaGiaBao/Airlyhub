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
    func build() -> (UIViewController, Observable<MyCardsBuilderAction>) {
        let interactor = MyCardsInteractor()
        let router = MyCardsRouter()
        let presenter = MyCardsPresenter(interactor: interactor,
                                         router: router)
        let view = MyCardsView(presenter: presenter)
        router.viewController = view
        return (view, presenter.myCardsBuilderAction)
    }
}

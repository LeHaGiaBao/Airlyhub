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
        let presenter = MyCardsPresenter()
        let view = MyCardsView(presenter: presenter)
        return (view, presenter.myCardsBuilderAction)
    }
}

//
//  MyCardsBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import UIKit
import RxSwift

enum MyCardsAction {
    case cancel
}

final class MyCardsBuilder {
    func build() -> (UIViewController, Observable<MyCardsAction>) {
        let presenter = MyCardsPresenter()
        let view = MyCardsView(presenter: presenter)
        return (view, presenter.myCardsAction)
    }
}

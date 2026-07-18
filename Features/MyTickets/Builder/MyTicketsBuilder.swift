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
    func build() -> (UIViewController, Observable<MyTicketsBuilderAction>) {
        let interactor = MyTicketsInteractor()
        let presenter = MyTicketsPresenter(interactor: interactor)
        let view = MyTicketsView(presenter: presenter)
        return (view, presenter.myTicketsBuilderAction)
    }
}

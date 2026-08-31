//
//  MyTicketDetailBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import RxSwift

enum MyTicketDetailBuilderAction {
    case cancel
}

final class MyTicketDetailBuilder {
    func build(ticket: TicketModel) -> (UIViewController, Observable<MyTicketDetailBuilderAction>) {
        let view = MyTicketDetailView()
        let interactor = MyTicketDetailInteractor()
        let router = MyTicketDetailRouter()
        let presenter = MyTicketDetailPresenter(view: view,
                                                interactor: interactor,
                                                router: router,
                                                ticket: ticket)
        view.presenter = presenter
        router.viewController = view
        return (view, presenter.myTicketDetailBuilderAction)
    }
}

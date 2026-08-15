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
    /// The ticket is injected rather than fetched by id: the list already holds the
    /// record, and a lookup here would only re-read the same mock — and, once there
    /// is a backend, would spend a round trip to redraw what was already on screen.
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

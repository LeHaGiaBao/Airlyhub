//
//  MyTicketsRouter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import RxSwift

final class MyTicketsRouter: MyTicketsRouterProtocol {
    weak var viewController: UIViewController?

    func navigateToTicketDetail(ticket: TicketModel) -> Observable<MyTicketDetailBuilderAction> {
        // The stack belongs to whoever pushed this module — Profiles — so it is
        // borrowed from the screen on it rather than held as a dependency. Nothing
        // to push onto means nothing happens, which is why this returns `.empty()`
        // instead of force-unwrapping its way to a crash.
        guard let nav = viewController?.navigationController else { return .empty() }

        let (view, signal) = MyTicketDetailBuilder().build(ticket: ticket)
        view.hidesBottomBarWhenPushed = true
        nav.pushViewController(view, animated: true)

        return signal.do(onCompleted: { [weak nav] in
            nav?.popViewController(animated: true)
        })
    }
}

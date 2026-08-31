//
//  NotificationsBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/03/2026.
//

import UIKit
import RxSwift

enum NotificationsBuilderAction {
    case cancel
}

final class NotificationsBuilder {
    func build() -> (UIViewController, Observable<NotificationsBuilderAction>) {
        let interactor = NotificationsInteractor()
        let router = NotificationsRouter()
        let presenter = NotificationsPresenter(interactor: interactor,
                                               router: router)
        let view = NotificationsView(presenter: presenter)
        router.viewController = view
        return (view, presenter.notificationsBuilderAction)
    }
}

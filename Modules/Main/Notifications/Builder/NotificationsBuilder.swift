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
        let presenter = NotificationsPresenter()
        let view = NotificationsView(presenter: presenter)
        return (view, presenter.notificationsBuilderAction)
    }
}

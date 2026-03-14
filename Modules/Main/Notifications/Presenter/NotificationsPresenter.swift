//
//  NotificationsPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/03/2026.
//

import RxSwift

final class NotificationsPresenter {
    private var _notificationsBuilderAction = BehaviorSubject<NotificationsBuilderAction>(value: .cancel)
    private var hasCompleted = false
    
    var notificationsBuilderAction: Observable<NotificationsBuilderAction> {
        _notificationsBuilderAction.asObservable()
    }
    
    func dismiss() {
        guard !hasCompleted else { return }
        hasCompleted = true
        _notificationsBuilderAction.onNext(.cancel)
        _notificationsBuilderAction.onCompleted()
    }
}

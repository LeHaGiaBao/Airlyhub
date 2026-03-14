//
//  NotificationsPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/03/2026.
//

import RxSwift

final class NotificationsPresenter {
    private var _notificationsAction = BehaviorSubject<NotificationsAction>(value: .cancel)
    private var hasCompleted = false
    
    var notificationsAction: Observable<NotificationsAction> {
        _notificationsAction.asObservable()
    }
    
    func dismiss() {
        guard !hasCompleted else { return }
        hasCompleted = true
        _notificationsAction.onNext(.cancel)
        _notificationsAction.onCompleted()
    }
}

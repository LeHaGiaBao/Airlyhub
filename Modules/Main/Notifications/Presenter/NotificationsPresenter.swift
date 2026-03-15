//
//  NotificationsPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/03/2026.
//

import RxSwift

final class NotificationsPresenter: NotificationsPresenterProtocol {
    private var _notificationsBuilderAction = BehaviorSubject<NotificationsBuilderAction>(value: .cancel)
    private var hasCompleted = false
    private let interactor: NotificationsInteractorProtocol
    
    init(interactor: NotificationsInteractorProtocol) {
        self.interactor = interactor
    }
    
    var notificationsBuilderAction: Observable<NotificationsBuilderAction> {
        _notificationsBuilderAction.asObservable()
    }
    
    func dismiss() {
        guard !hasCompleted else { return }
        hasCompleted = true
        _notificationsBuilderAction.onNext(.cancel)
        _notificationsBuilderAction.onCompleted()
    }
    
    func getNotifications() -> [NotificationsEntity] {
        return interactor.fetchNotifications()
    }
}

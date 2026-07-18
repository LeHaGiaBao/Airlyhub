//
//  SettingsPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import RxSwift

final class SettingsPresenter: SettingsPresenterProtocol {
    private var _settingsBuilderAction = BehaviorSubject<SettingsBuilderAction>(value: .cancel)
    private var hasCompleted = false
    private let interactor: SettingsInteractorProtocol
    private let router: SettingsRouterProtocol

    init(interactor: SettingsInteractorProtocol,
         router: SettingsRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    var settingsBuilderAction: Observable<SettingsBuilderAction> {
        _settingsBuilderAction.asObservable()
    }
    
    func dismiss() {
        guard !hasCompleted else { return }
        hasCompleted = true
        _settingsBuilderAction.onNext(.cancel)
        _settingsBuilderAction.onCompleted()
    }
}

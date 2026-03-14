//
//  SettingsPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import RxSwift

final class SettingsPresenter {
    private var _settingsAction = BehaviorSubject<SettingsAction>(value: .cancel)
    private var hasCompleted = false
    
    var settingsAction: Observable<SettingsAction> {
        _settingsAction.asObservable()
    }
    
    func dismiss() {
        guard !hasCompleted else { return }
        hasCompleted = true
        _settingsAction.onNext(.cancel)
        _settingsAction.onCompleted()
    }
}

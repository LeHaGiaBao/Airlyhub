//
//  SettingsPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import RxSwift

final class SettingsPresenter {
    private var _settingsBuilderAction = BehaviorSubject<SettingsBuilderAction>(value: .cancel)
    private var hasCompleted = false
    
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

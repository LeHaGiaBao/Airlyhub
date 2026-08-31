//
//  SettingsPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import Foundation
import RxSwift

final class SettingsPresenter: SettingsPresenterProtocol {
    weak var view: SettingsViewProtocol?

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

    func getSettingItems() -> [SettingsItem] {
        interactor.fetchSettings()
    }

    func didSelectItem(_ item: SettingsItem) {
        switch item.type {
        case .language:
            presentLanguageSelection()
        case .aboutUs:
            router.presentAboutUs()
        case .pushNotifications:
            break
        }
    }

    func viewWillAppear() {
        guard interactor.isPushNotificationEnabled() else { return }
        interactor.pushAuthorizationState { [weak self] state in
            guard let self else { return }
            if state != .authorized {
                self.interactor.setPushNotificationEnabled(false)
                self.view?.setPushNotificationToggle(false)
            }
        }
    }

    func didTogglePushNotifications(isOn: Bool) {
        guard isOn else {
            interactor.setPushNotificationEnabled(false)
            view?.showToast(NSLocalizedString("push_notifications_disabled", comment: ""), style: .info)
            return
        }

        interactor.pushAuthorizationState { [weak self] state in
            guard let self else { return }
            switch state {
            case .authorized:
                self.enablePushNotifications()
            case .notDetermined:
                self.interactor.requestPushAuthorization { granted in
                    if granted {
                        self.enablePushNotifications()
                    } else {
                        self.rejectPushNotifications()
                    }
                }
            case .denied:
                self.rejectPushNotifications()
            }
        }
    }

    private func enablePushNotifications() {
        interactor.setPushNotificationEnabled(true)
        view?.showToast(NSLocalizedString("push_notifications_enabled", comment: ""), style: .success)
    }

    private func rejectPushNotifications() {
        interactor.setPushNotificationEnabled(false)
        view?.setPushNotificationToggle(false)
        view?.showToast(NSLocalizedString("push_notifications_denied_hint", comment: ""), style: .info)
    }

    private func presentLanguageSelection() {
        router.presentLanguageSelection(languages: interactor.availableLanguages(),
                                        current: interactor.currentLanguage()) { [weak self] selected in
            self?.handleLanguageSelection(selected)
        }
    }

    private func handleLanguageSelection(_ language: AppLanguage) {
        guard language != interactor.currentLanguage() else { return }
        interactor.setLanguage(language)
        router.reloadForLanguageChange()
    }
}

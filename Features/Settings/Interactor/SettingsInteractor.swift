//
//  SettingsInteractor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import Foundation

final class SettingsInteractor: SettingsInteractorProtocol {
    func fetchSettings() -> [SettingsItem] {
        return [
            SettingsItem(type: .language,
                         title: NSLocalizedString("application_language", comment: ""),
                         icon: AssetsIcon.earth,
                         accessory: .value(LanguageManager.shared.currentLanguage.displayName)),
            SettingsItem(type: .pushNotifications,
                         title: NSLocalizedString("push_notifications", comment: ""),
                         icon: AssetsIcon.badge,
                         accessory: .toggle(PushNotificationManager.shared.isEnabled)),
            SettingsItem(type: .aboutUs,
                         title: NSLocalizedString("about_us", comment: ""),
                         icon: AssetsIcon.blueAirplane,
                         accessory: .none)
        ]
    }

    func availableLanguages() -> [AppLanguage] {
        LanguageManager.shared.availableLanguages
    }

    func currentLanguage() -> AppLanguage {
        LanguageManager.shared.currentLanguage
    }

    func setLanguage(_ language: AppLanguage) {
        LanguageManager.shared.setLanguage(language)
    }

    // MARK: - Push notifications
    func isPushNotificationEnabled() -> Bool {
        PushNotificationManager.shared.isEnabled
    }

    func setPushNotificationEnabled(_ enabled: Bool) {
        PushNotificationManager.shared.isEnabled = enabled
    }

    func pushAuthorizationState(_ completion: @escaping (PushAuthorizationState) -> Void) {
        PushNotificationManager.shared.authorizationState(completion)
    }

    func requestPushAuthorization(_ completion: @escaping (Bool) -> Void) {
        PushNotificationManager.shared.requestAuthorization(completion)
    }
}

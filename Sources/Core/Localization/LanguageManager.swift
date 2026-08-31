//
//  LanguageManager.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

final class LanguageManager {
    static let shared = LanguageManager()

    private let defaultsKey = "app_selected_language"

    private init() {}

    var availableLanguages: [AppLanguage] {
        AppLanguage.allCases
    }

    var currentLanguage: AppLanguage {
        if let raw = UserDefaults.standard.string(forKey: defaultsKey),
           let language = AppLanguage(rawValue: raw) {
            return language
        }

        let preferred = Locale.preferredLanguages.first ?? AppLanguage.english.rawValue
        return preferred.hasPrefix(AppLanguage.vietnamese.rawValue) ? .vietnamese : .english
    }

    func applyCurrentLanguage() {
        Bundle.setLanguage(currentLanguage.rawValue)
    }

    func setLanguage(_ language: AppLanguage) {
        UserDefaults.standard.set(language.rawValue, forKey: defaultsKey)
        UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
        Bundle.setLanguage(language.rawValue)
    }
}

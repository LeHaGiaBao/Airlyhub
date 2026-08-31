//
//  AppLanguage.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

enum AppLanguage: String, CaseIterable {
    case english = "en"
    case vietnamese = "vi"

    var localizedNameKey: String {
        switch self {
        case .english: return "english"
        case .vietnamese: return "vietnam"
        }
    }

    var displayName: String {
        NSLocalizedString(localizedNameKey, comment: "")
    }
}

//
//  AppInfo.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 19/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Read-only access to app metadata from the main bundle's Info.plist.
enum AppInfo {
    static var name: String {
        (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String)
            ?? (Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String)
            ?? NSLocalizedString("airlyhub", comment: "")
    }

    static var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
    }
}

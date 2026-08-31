//
//  SettingsEntity.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import UIKit

enum SettingsRowAccessory {
    case value(String)
    case toggle(Bool)
    case none
}

enum SettingsItemType {
    case language
    case pushNotifications
    case aboutUs
}

struct SettingsItem {
    let type: SettingsItemType
    let title: String
    let icon: UIImage?
    let accessory: SettingsRowAccessory
}

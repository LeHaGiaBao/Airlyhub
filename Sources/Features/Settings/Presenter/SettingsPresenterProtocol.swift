//
//  SettingsPresenterProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol SettingsPresenterProtocol: AnyObject {
    func dismiss()
    func getSettingItems() -> [SettingsItem]
    func didSelectItem(_ item: SettingsItem)
    func viewWillAppear()
    func didTogglePushNotifications(isOn: Bool)
}

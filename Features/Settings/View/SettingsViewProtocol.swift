//
//  SettingsViewProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol SettingsViewProtocol: AnyObject {
    func setPushNotificationToggle(_ isOn: Bool)
    func showToast(_ message: String, style: ToastStyle)
}

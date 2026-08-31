//
//  PushNotificationManager.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import UserNotifications

final class PushNotificationManager {
    static let shared = PushNotificationManager()

    private let preferenceKey = "app_push_notifications_enabled"

    private init() {}

    var isEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: preferenceKey) }
        set { UserDefaults.standard.set(newValue, forKey: preferenceKey) }
    }

    func authorizationState(_ completion: @escaping (PushAuthorizationState) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(Self.map(settings.authorizationStatus))
            }
        }
    }

    func requestAuthorization(_ completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
    }

    private static func map(_ status: UNAuthorizationStatus) -> PushAuthorizationState {
        switch status {
        case .notDetermined:
            return .notDetermined
        case .denied:
            return .denied
        case .authorized, .provisional, .ephemeral:
            return .authorized
        @unknown default:
            return .denied
        }
    }
}

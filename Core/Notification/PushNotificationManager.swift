//
//  PushNotificationManager.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import UserNotifications

// MARK: - PushNotificationManager
final class PushNotificationManager {
    static let shared = PushNotificationManager()

    private let preferenceKey = "app_push_notifications_enabled"

    private init() {}

    /// App-level preference for whether the user wants push notifications on.
    /// System permission is a separate concern handled via `authorizationState`.
    var isEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: preferenceKey) }
        set { UserDefaults.standard.set(newValue, forKey: preferenceKey) }
    }

    /// Current system authorization status, delivered on the main thread.
    func authorizationState(_ completion: @escaping (PushAuthorizationState) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(Self.map(settings.authorizationStatus))
            }
        }
    }

    /// Requests notification permission. Only shows the system modal when the
    /// status is `.notDetermined`; otherwise iOS resolves immediately.
    /// Result is delivered on the main thread.
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

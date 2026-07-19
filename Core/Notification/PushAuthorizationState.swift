//
//  PushAuthorizationState.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 19/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

// MARK: - PushAuthorizationState
/// App-level abstraction over `UNAuthorizationStatus` so the VIPER layers
/// don't need to depend on UserNotifications details.
enum PushAuthorizationState {
    case notDetermined
    case denied
    case authorized
}

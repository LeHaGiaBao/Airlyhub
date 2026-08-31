//
//  ChatPolicy.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 31/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Business limits on the support thread, shared by the repository (enforcement),
/// the security rules (which mirror them) and the UI (the "too long" message).
enum ChatPolicy {
    static let maxMessageLength = 4000
}

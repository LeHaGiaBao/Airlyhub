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
    /// Longest message the rules will accept — checked client-side first so an
    /// over-long message is refused with a readable error, not a permission code.
    static let maxMessageLength = 4000
}

//
//  CardPolicy.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 31/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Business limits on saved cards, shared by the repository (which enforces them)
/// and the UI (which explains them in the "limit reached" message).
enum CardPolicy {
    static let maxPerUser = 5
}

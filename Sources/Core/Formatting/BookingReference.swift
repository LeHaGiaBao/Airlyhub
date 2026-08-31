//
//  BookingReference.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Generates the short "673-843" label shown as a ticket's id and barcode payload.
enum BookingReference {
    static func make() -> String {
        String(format: "%03d-%03d", Int.random(in: 100...999), Int.random(in: 100...999))
    }
}

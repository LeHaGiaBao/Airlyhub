//
//  BookingReference.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Generates the short "673-843" label shown as a ticket's id and barcode payload.
///
/// Client-generated rather than derived from the Firestore document id: an auto-id
/// is a long opaque string, unusable as something a person reads off a boarding
/// pass. Both `BookingService` and `MockBookingRepository` call this so the two
/// produce reference numbers in the same shape.
enum BookingReference {
    static func make() -> String {
        String(format: "%03d-%03d", Int.random(in: 100...999), Int.random(in: 100...999))
    }
}

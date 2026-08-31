//
//  CardModel.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// A saved card as the app knows it.
struct CardModel: Equatable {
    let id: String
    let brand: CardBrand
    let last4: String
    let holderName: String
    let expMonth: Int
    let expYear: Int
    let isDefault: Bool
    let status: CardStatus
    let createdAt: Date

    let token: String?
    let encrypted: EncryptedPayload?

    var expiryDisplay: String {
        String(format: "%d/%02d", expMonth, expYear % 100)
    }

    var isExpired: Bool {
        var components = DateComponents()
        components.year = expYear
        components.month = expMonth + 1
        components.day = 1

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        guard let firstDayAfterExpiry = calendar.date(from: components) else { return false }
        return Date() >= firstDayAfterExpiry
    }

    var isSelectable: Bool {
        !isExpired && status == .active
    }
}

enum CardStatus: String, Codable {
    case active
    case expired
    case revoked
}

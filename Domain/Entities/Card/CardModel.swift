//
//  CardModel.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// A saved card as the app knows it.
///
/// Deliberately has no field carrying a plaintext PAN — `last4` is the only part of
/// the number that reaches this layer. The full number, when stored at all, lives
/// encrypted in `encrypted` and is only opened at charge time.
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

    /// Payment-provider token (tokenization flow). `nil` in the encryption flow.
    let token: String?
    /// AES-256-GCM ciphertext of the PAN (encryption flow). `nil` in the tokenization flow.
    let encrypted: EncryptedPayload?

    /// Expiry as rendered on the list, e.g. "1/30".
    var expiryDisplay: String {
        String(format: "%d/%02d", expMonth, expYear % 100)
    }

    /// A card stays valid through the last day of its expiry month.
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

    /// Only a usable card can be picked as the default one.
    var isSelectable: Bool {
        !isExpired && status == .active
    }
}

enum CardStatus: String, Codable {
    case active
    case expired
    case revoked
}

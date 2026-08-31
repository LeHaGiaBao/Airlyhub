//
//  NewCard.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 31/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Everything the app knows about a card it is about to save, in domain terms —
/// the input to `CardRepositoryProtocol.addCard`.
struct NewCard: Equatable {
    let userId: String
    let brand: CardBrand
    let last4: String
    let holderName: String
    let expMonth: Int
    let expYear: Int
    let isDefault: Bool
    let encrypted: EncryptedPayload?
    let token: String?

    init(userId: String,
         brand: CardBrand,
         last4: String,
         holderName: String,
         expMonth: Int,
         expYear: Int,
         isDefault: Bool,
         encrypted: EncryptedPayload? = nil,
         token: String? = nil) {
        self.userId = userId
        self.brand = brand
        self.last4 = last4
        self.holderName = holderName
        self.expMonth = expMonth
        self.expYear = expYear
        self.isDefault = isDefault
        self.encrypted = encrypted
        self.token = token
    }
}

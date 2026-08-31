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
///
/// Assembling the Firestore document (`CardDTO`) from this is the repository's job,
/// so the interactor never touches a `Data` type. Deliberately carries no `cvv`:
/// PCI-DSS forbids storing the security code even encrypted, and leaving it off the
/// type makes that impossible to get wrong.
struct NewCard: Equatable {
    let userId: String
    let brand: CardBrand
    let last4: String
    let holderName: String
    let expMonth: Int
    let expYear: Int
    /// The first card a user saves becomes their default.
    let isDefault: Bool
    /// AES-256-GCM ciphertext of the PAN (encryption flow). `nil` in the tokenization flow.
    let encrypted: EncryptedPayload?
    /// Payment-provider token (tokenization flow). `nil` in the encryption flow.
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

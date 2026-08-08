//
//  CardDTO.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import FirebaseFirestore

/// Firestore representation of `cards/{cardId}`.
///
/// The field set here is mirrored by the security rules' whitelist — anything not
/// listed is rejected server-side, which is what keeps a `cvv` field from ever
/// reaching the database even if the client is tampered with.
struct CardDTO: Codable {
    /// Owner's Firebase Auth uid. In a top-level collection this field *is* the
    /// access-control boundary, so the rules both require it to match the caller
    /// and forbid changing it on update.
    let userId: String
    let brand: String
    let last4: String
    let holderName: String
    let expMonth: Int
    let expYear: Int
    let isDefault: Bool
    let status: String
    let token: String?
    let encrypted: EncryptedPayload?

    /// Left nil on write so Firestore stamps the server clock; the rules require
    /// these to equal `request.time`, so a client-supplied value would be rejected.
    @ServerTimestamp var createdAt: Timestamp?
    @ServerTimestamp var updatedAt: Timestamp?
}

// MARK: - Mapping
extension CardDTO {
    func toDomain(id: String) -> CardModel {
        CardModel(
            id: id,
            brand: CardBrand(rawValue: brand) ?? .unknown,
            last4: last4,
            holderName: holderName,
            expMonth: expMonth,
            expYear: expYear,
            isDefault: isDefault,
            status: CardStatus(rawValue: status) ?? .active,
            createdAt: createdAt?.dateValue() ?? Date(),
            token: token,
            encrypted: encrypted
        )
    }

    /// Everything needed to describe a new card except the secret itself.
    ///
    /// There is deliberately no `cvv` field: PCI-DSS forbids storing the security code
    /// even encrypted, and leaving it out of the type makes that impossible to get wrong.
    struct Draft {
        let userId: String
        let brand: CardBrand
        let last4: String
        let holderName: String
        let expMonth: Int
        let expYear: Int
        let isDefault: Bool
    }

    /// Builds the document for a newly added card.
    /// `token` (tokenization) and `encrypted` (client-side encryption) are mutually
    /// exclusive — the security rules reject a document carrying both.
    static func make(_ draft: Draft,
                     token: String? = nil,
                     encrypted: EncryptedPayload? = nil) -> CardDTO {
        CardDTO(
            userId: draft.userId,
            brand: draft.brand.rawValue,
            last4: draft.last4,
            holderName: draft.holderName,
            expMonth: draft.expMonth,
            expYear: draft.expYear,
            isDefault: draft.isDefault,
            status: CardStatus.active.rawValue,
            token: token,
            encrypted: encrypted,
            createdAt: nil,
            updatedAt: nil
        )
    }
}

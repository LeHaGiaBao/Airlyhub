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
struct CardDTO: Codable {
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

    @ServerTimestamp var createdAt: Timestamp?
    @ServerTimestamp var updatedAt: Timestamp?
}

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

    struct Draft {
        let userId: String
        let brand: CardBrand
        let last4: String
        let holderName: String
        let expMonth: Int
        let expYear: Int
        let isDefault: Bool
    }

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

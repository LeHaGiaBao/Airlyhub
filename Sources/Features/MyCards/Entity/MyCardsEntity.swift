//
//  MyCardsEntity.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import Foundation

/// Row view model. Already masked and formatted, so the view never handles
/// anything closer to raw card data than these strings.
struct CardItem: Equatable {
    let id: String
    let brand: CardBrand
    let maskedNumber: String
    let expiryDisplay: String
    let isDefault: Bool
    let isExpired: Bool
    let isSelectable: Bool
}

enum MyCardsViewState: Equatable {
    case loading
    case loaded([CardItem])
    case failed(String)
}

struct NewCardInput {
    let number: String
    let holderName: String
    let expMonth: Int
    let expYear: Int
    let cvv: String
}

enum MyCardsError: LocalizedError, Equatable {
    case notAuthenticated
    case invalidCard
    case duplicatedCard
    case cardLimitReached

    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return NSLocalizedString("error_not_authenticated", comment: "")
        case .invalidCard:
            return NSLocalizedString("validation_invalid_card_number", comment: "")
        case .duplicatedCard:
            return NSLocalizedString("error_card_duplicated", comment: "")
        case .cardLimitReached:
            return String(
                format: NSLocalizedString("error_card_limit_reached", comment: ""),
                CardPolicy.maxPerUser
            )
        }
    }
}

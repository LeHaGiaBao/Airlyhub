//
//  CardBrand.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

/// Card scheme identified from the card number's BIN / prefix.
enum CardBrand: String, Codable, CaseIterable {
    case visa
    case mastercard
    case amex
    case jcb
    case discover
    case dinersClub
    case unionPay
    case mir
    case unknown

    /// Name shown next to the masked number, e.g. "MasterCard •••• 2321".
    var displayName: String {
        switch self {
        case .visa: return "Visa"
        case .mastercard: return "MasterCard"
        case .amex: return "American Express"
        case .jcb: return "JCB"
        case .discover: return "Discover"
        case .dinersClub: return "Diners Club"
        case .unionPay: return "UnionPay"
        case .mir: return "MIR"
        case .unknown: return NSLocalizedString("card_brand_unknown", comment: "")
        }
    }

    /// Short label used as a placeholder while the brand logo asset is missing.
    var shortName: String {
        switch self {
        case .visa: return "VISA"
        case .mastercard: return "MC"
        case .amex: return "AMEX"
        case .jcb: return "JCB"
        case .discover: return "DISC"
        case .dinersClub: return "DINERS"
        case .unionPay: return "UNION"
        case .mir: return "MIR"
        case .unknown: return "CARD"
        }
    }

    /// Brand badge from `Assets.xcassets/PaymentMethods` (36×24, artwork carries its
    /// own background). Mapped explicitly because several asset names don't match the
    /// case names — e.g. `amex` ships as `ameriaexpress`.
    var logo: UIImage? {
        switch self {
        case .visa: return AssetsIcon.visa
        case .mastercard: return AssetsIcon.mastercard
        case .amex: return AssetsIcon.americanExpress
        case .jcb: return AssetsIcon.jcb
        case .discover: return AssetsIcon.discover
        case .dinersClub: return AssetsIcon.dinersClub
        case .unionPay: return AssetsIcon.unionPay
        case .mir: return AssetsIcon.mir
        case .unknown: return nil
        }
    }

    /// Native size of the badge artwork; keeps the 3:2 aspect ratio wherever it's shown.
    static let logoSize = CGSize(width: 36, height: 24)

    /// Valid digit counts for the card number (spaces excluded).
    var validLengths: [Int] {
        switch self {
        case .visa: return [13, 16, 19]
        case .mastercard: return [16]
        case .amex: return [15]
        case .jcb: return [16, 17, 18, 19]
        case .discover: return [16, 19]
        case .dinersClub: return [14, 16, 19]
        case .unionPay: return [16, 17, 18, 19]
        case .mir: return [16, 17, 18, 19]
        case .unknown: return Array(12...19)
        }
    }

    /// Amex uses a 4-digit CID, every other scheme uses a 3-digit CVV/CVC.
    var cvvLength: Int { self == .amex ? 4 : 3 }

    /// Digit indices a space is inserted before. Amex 4-6-5, Diners 4-6-4, others 4-4-4-4.
    var gaps: [Int] {
        switch self {
        case .amex, .dinersClub: return [4, 10]
        default: return [4, 8, 12, 16]
        }
    }

    var maxLength: Int { validLengths.max() ?? 19 }
}

// MARK: - BIN detection
extension CardBrand {
    /// A prefix interval, e.g. Mastercard's `2221...2720` over 4 digits.
    private struct PrefixRange {
        let low: Int
        let high: Int
        let length: Int

        /// Partial-prefix match: both the input and the interval are truncated to the
        /// same digit count before comparing, so a brand can be recognised from the
        /// very first keystroke and revised as the user keeps typing.
        func matches(_ digits: String) -> Bool {
            let count = min(length, digits.count)
            guard count > 0, let value = Int(digits.prefix(count)) else { return false }
            let divisor = Int(pow(10.0, Double(length - count)))
            guard divisor > 0 else { return false }
            return value >= low / divisor && value <= high / divisor
        }
    }

    private struct BrandRule {
        let brand: CardBrand
        let prefixes: [PrefixRange]
    }

    private static let rules: [BrandRule] = [
        BrandRule(brand: .visa, prefixes: [
            PrefixRange(low: 4, high: 4, length: 1)
        ]),
        BrandRule(brand: .mastercard, prefixes: [
            PrefixRange(low: 51, high: 55, length: 2),
            PrefixRange(low: 2221, high: 2720, length: 4)
        ]),
        BrandRule(brand: .amex, prefixes: [
            PrefixRange(low: 34, high: 34, length: 2),
            PrefixRange(low: 37, high: 37, length: 2)
        ]),
        BrandRule(brand: .jcb, prefixes: [
            PrefixRange(low: 3528, high: 3589, length: 4)
        ]),
        BrandRule(brand: .discover, prefixes: [
            PrefixRange(low: 6011, high: 6011, length: 4),
            PrefixRange(low: 644, high: 649, length: 3),
            PrefixRange(low: 65, high: 65, length: 2),
            // Overlaps UnionPay's `62`; the longer prefix wins in `detect(from:)`.
            PrefixRange(low: 622126, high: 622925, length: 6)
        ]),
        BrandRule(brand: .dinersClub, prefixes: [
            PrefixRange(low: 300, high: 305, length: 3),
            PrefixRange(low: 3095, high: 3095, length: 4),
            PrefixRange(low: 36, high: 36, length: 2),
            PrefixRange(low: 38, high: 39, length: 2)
        ]),
        BrandRule(brand: .unionPay, prefixes: [
            PrefixRange(low: 62, high: 62, length: 2),
            PrefixRange(low: 81, high: 81, length: 2)
        ]),
        BrandRule(brand: .mir, prefixes: [
            PrefixRange(low: 2200, high: 2204, length: 4)
        ])
    ]

    /// Identifies the scheme from however many digits are available.
    /// The longest matching prefix wins, so `622126…` resolves to Discover
    /// rather than UnionPay's shorter `62`.
    static func detect(from raw: String) -> CardBrand {
        let digits = raw.filter(\.isNumber)
        guard !digits.isEmpty else { return .unknown }

        var bestBrand: CardBrand = .unknown
        var bestLength = -1

        for rule in rules {
            for prefix in rule.prefixes where prefix.matches(digits) {
                if prefix.length > bestLength {
                    bestLength = prefix.length
                    bestBrand = rule.brand
                }
            }
        }
        return bestBrand
    }
}

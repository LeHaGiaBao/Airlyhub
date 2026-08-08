//
//  CardValidation.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

enum CardValidation {

    // MARK: Luhn

    /// Luhn (ISO/IEC 7812-1) checksum.
    ///
    /// This catches mistyped digits, nothing more — it says nothing about whether the
    /// card exists, is active, or has funds. Its value is saving a round-trip to the
    /// gateway for the ~90% of failures that are simple typos.
    static func passesLuhn(_ raw: String) -> Bool {
        let digits = raw.filter(\.isNumber)
        guard digits.count >= 12 else { return false }

        var sum = 0
        for (index, character) in digits.reversed().enumerated() {
            guard let digit = character.wholeNumberValue else { return false }
            if index % 2 == 1 {
                let doubled = digit * 2
                sum += doubled > 9 ? doubled - 9 : doubled
            } else {
                sum += digit
            }
        }
        return sum % 10 == 0
    }

    // MARK: Card number

    /// Three gates: the brand must be recognisable, the length must be one the brand
    /// actually issues, and the checksum must hold.
    static func validCardNumber(_ value: String?) -> ValidationResult {
        let digits = (value ?? "").filter(\.isNumber)

        guard !digits.isEmpty else {
            return .invalid(message: NSLocalizedString("validation_required_card_number", comment: ""))
        }

        let brand = CardBrand.detect(from: digits)
        guard brand != .unknown else {
            return .invalid(message: NSLocalizedString("validation_invalid_card_brand", comment: ""))
        }
        guard brand.validLengths.contains(digits.count) else {
            return .invalid(message: NSLocalizedString("validation_invalid_card_length", comment: ""))
        }
        guard passesLuhn(digits) else {
            return .invalid(message: NSLocalizedString("validation_invalid_card_number", comment: ""))
        }
        return .valid
    }

    // MARK: Expiry (MM/YY)

    /// Rejects months outside 1–12, cards already past their expiry month, and dates
    /// more than 20 years out (almost always a mistyped year).
    static func validExpiry(_ value: String?) -> ValidationResult {
        let digits = (value ?? "").filter(\.isNumber)

        guard !digits.isEmpty else {
            return .invalid(message: NSLocalizedString("validation_required_card_expiry", comment: ""))
        }
        guard digits.count == 4,
              let month = Int(digits.prefix(2)),
              let shortYear = Int(digits.suffix(2)) else {
            return .invalid(message: NSLocalizedString("validation_invalid_card_expiry_format", comment: ""))
        }
        guard (1...12).contains(month) else {
            return .invalid(message: NSLocalizedString("validation_invalid_card_expiry_month", comment: ""))
        }

        let year = 2000 + shortYear
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        let now = Date()

        // A card is good through the last day of its expiry month, so compare against
        // the first day of the month after it.
        var components = DateComponents()
        components.year = year
        components.month = month + 1
        components.day = 1
        guard let firstDayAfterExpiry = calendar.date(from: components) else {
            return .invalid(message: NSLocalizedString("validation_invalid_card_expiry_format", comment: ""))
        }
        guard firstDayAfterExpiry > now else {
            return .invalid(message: NSLocalizedString("validation_invalid_card_expired", comment: ""))
        }

        let currentYear = calendar.component(.year, from: now)
        guard year <= currentYear + 20 else {
            return .invalid(message: NSLocalizedString("validation_invalid_card_expiry_too_far", comment: ""))
        }
        return .valid
    }

    // MARK: CVV / CVC

    /// Amex expects 4 digits, everything else 3. An `.unknown` brand accepts 3–4 so the
    /// user isn't shown an error before they've typed enough digits to identify the scheme.
    static func validCVV(_ value: String?, brand: CardBrand) -> ValidationResult {
        let digits = (value ?? "").filter(\.isNumber)

        guard !digits.isEmpty else {
            return .invalid(message: NSLocalizedString("validation_required_card_cvv", comment: ""))
        }

        if brand == .unknown {
            guard (3...4).contains(digits.count) else {
                return .invalid(message: NSLocalizedString("validation_invalid_card_cvv", comment: ""))
            }
            return .valid
        }

        guard digits.count == brand.cvvLength else {
            let message = String(
                format: NSLocalizedString("validation_invalid_card_cvv_length", comment: ""),
                brand.cvvLength
            )
            return .invalid(message: message)
        }
        return .valid
    }

    // MARK: Holder name

    static func validHolderName(_ value: String?) -> ValidationResult {
        guard let value = value, !value.trimmingCharacters(in: .whitespaces).isEmpty else {
            return .invalid(message: NSLocalizedString("validation_required_card_holder", comment: ""))
        }
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        guard (2...26).contains(trimmed.count),
              Regexes.matches(Regexes.cardHolderName, input: trimmed) else {
            return .invalid(message: NSLocalizedString("validation_invalid_card_holder", comment: ""))
        }
        return .valid
    }
}

//
//  CardFormatter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

enum CardFormatter {

    enum MaskStyle {
        /// "MasterCard •••• 2321" — what the list rows show.
        case compact
        /// "•••• •••• •••• 2321" — full-width mask for detail surfaces.
        case full
    }

    /// Groups digits per the brand's gaps: "4500091043343443" → "4500 0910 4334 3443".
    static func formatNumber(_ raw: String, brand: CardBrand) -> String {
        let digits = String(raw.filter(\.isNumber).prefix(brand.maxLength))
        var result = ""
        for (index, character) in digits.enumerated() {
            if brand.gaps.contains(index) { result.append(" ") }
            result.append(character)
        }
        return result
    }

    /// "1030" → "10/30". Drives the expiry field's auto-inserted slash.
    static func formatExpiry(_ raw: String) -> String {
        let digits = String(raw.filter(\.isNumber).prefix(4))
        guard digits.count > 2 else { return digits }
        return "\(digits.prefix(2))/\(digits.dropFirst(2))"
    }

    /// Builds the masked display string.
    ///
    /// Takes `last4` rather than a PAN on purpose: there is no code path by which a full
    /// card number can reach the UI layer, because this function cannot accept one.
    static func masked(last4: String, brand: CardBrand, style: MaskStyle = .compact) -> String {
        switch style {
        case .compact:
            return "\(brand.displayName) •••• \(last4)"

        case .full:
            // `formatNumber` strips non-digits, so the grouping is applied by hand here.
            let totalLength = brand.validLengths.first ?? 16
            let hiddenCount = max(totalLength - last4.count, 0)
            let characters = Array(repeating: "•", count: hiddenCount) + last4.map(String.init)

            var result = ""
            for (index, character) in characters.enumerated() {
                if brand.gaps.contains(index) { result.append(" ") }
                result.append(character)
            }
            return result
        }
    }
}

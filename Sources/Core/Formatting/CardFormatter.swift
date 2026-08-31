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
        case compact
        case full
    }

    static func formatNumber(_ raw: String, brand: CardBrand) -> String {
        let digits = String(raw.filter(\.isNumber).prefix(brand.maxLength))
        var result = ""
        for (index, character) in digits.enumerated() {
            if brand.gaps.contains(index) { result.append(" ") }
            result.append(character)
        }
        return result
    }

    static func formatExpiry(_ raw: String) -> String {
        let digits = String(raw.filter(\.isNumber).prefix(4))
        guard digits.count > 2 else { return digits }
        return "\(digits.prefix(2))/\(digits.dropFirst(2))"
    }

    static func masked(last4: String, brand: CardBrand, style: MaskStyle = .compact) -> String {
        switch style {
        case .compact:
            return "\(brand.displayName) •••• \(last4)"

        case .full:
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

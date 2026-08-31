//
//  TourFormatter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Strings shown on a tour card.
enum TourFormatter {
    private static let ratingFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }()

    private static var priceFormatters: [String: NumberFormatter] = [:]

    private static let summaryDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMMd")
        return formatter
    }()

    static func rating(_ value: Double?) -> String? {
        guard let value else { return nil }
        return ratingFormatter.string(from: NSNumber(value: value))
    }

    static func price(_ amount: Decimal, currencyCode: String) -> String {
        let formatter = priceFormatter(for: currencyCode)
        let number = NSDecimalNumber(decimal: amount)
        return formatter.string(from: number) ?? "\(number)"
    }

    static func summaryDate(_ date: Date) -> String {
        summaryDateFormatter.string(from: date)
    }

    static func airfield(_ name: String) -> String {
        String(format: NSLocalizedString("tour_airfield", comment: ""), name)
    }

    static func passengers(_ count: Int) -> String {
        String(format: NSLocalizedString("tour_passengers", comment: ""), count)
    }

    private static func priceFormatter(for currencyCode: String) -> NumberFormatter {
        if let cached = priceFormatters[currencyCode] { return cached }

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.maximumFractionDigits = 0
        priceFormatters[currencyCode] = formatter
        return formatter
    }
}

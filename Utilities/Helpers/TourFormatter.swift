//
//  TourFormatter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Strings shown on a tour card.
///
/// Formatters are static for the same reason as `ChatFormatter`'s: building one is
/// expensive and a scrolling list re-renders these for every visible row.
enum TourFormatter {
    private static let ratingFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }()

    /// Currency formatters are cached per code: the catalog prices in the
    /// operator's currency, so one screen can show several at once.
    private static var priceFormatters: [String: NumberFormatter] = [:]

    /// Day and month without a year, as the search header shows it ("July 30").
    /// `setLocalizedDateFormatFromTemplate` rather than a literal pattern, so the
    /// order flips for locales that write the day first.
    private static let summaryDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMMd")
        return formatter
    }()

    /// "4.7", or nil when the record has no reviews — the caller hides the badge.
    static func rating(_ value: Double?) -> String? {
        guard let value else { return nil }
        return ratingFormatter.string(from: NSNumber(value: value))
    }

    /// "2000 ₽". Grouping and symbol placement follow the device locale while the
    /// symbol itself comes from the record, so a Vietnamese user sees "2.000 ₽"
    /// rather than the price silently re-labelled as đồng.
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
        // Catalog prices are whole units; trailing ",00" is noise on a card.
        formatter.maximumFractionDigits = 0
        priceFormatters[currencyCode] = formatter
        return formatter
    }
}

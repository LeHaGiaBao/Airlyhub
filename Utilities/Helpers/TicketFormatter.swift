//
//  TicketFormatter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Strings shown on a ticket — the counterpart to `TourFormatter` for `BookingModel`.
///
/// Price reuses `TourFormatter.price` rather than a second currency formatter here:
/// a booking's amount and a tour's price are formatted identically, so duplicating
/// that cache would only risk the two drifting apart.
enum TicketFormatter {
    /// Fixed "dd.MM.yyyy" rather than a locale template — a ticket's date of flight
    /// reads as a document field (like a boarding pass would print it), not as
    /// prose, so it does not follow the device's date-order preference the way
    /// `TourFormatter.summaryDate` does.
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()

    static func date(_ date: Date) -> String {
        dateFormatter.string(from: date)
    }

    /// "35 min". Reuses the detail screen's own duration-pill format so a tour's
    /// chosen length reads the same on the ticket as it did on the pill the user
    /// tapped.
    static func duration(minutes: Int) -> String {
        String(format: NSLocalizedString("tour_detail_duration_minutes", comment: ""), minutes)
    }
}

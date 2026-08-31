//
//  TicketFormatter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Strings shown on a ticket — the counterpart to `TourFormatter` for `BookingModel`.
enum TicketFormatter {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()

    static func date(_ date: Date) -> String {
        dateFormatter.string(from: date)
    }

    static func duration(minutes: Int) -> String {
        String(format: NSLocalizedString("tour_detail_duration_minutes", comment: ""), minutes)
    }
}

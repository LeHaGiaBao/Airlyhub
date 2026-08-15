//
//  ChatFormatter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Date and time strings for the support thread.
///
/// The formatters are held as statics because building a `DateFormatter` is expensive
/// and the chat re-renders them for every visible row on each snapshot.
enum ChatFormatter {
    /// Follows the device's 12/24-hour setting, so this is "12:02" or "12:02 PM"
    /// depending on the user's region — never a hardcoded pattern.
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter
    }()

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    /// Time shown under a bubble, e.g. "12:02".
    static func time(_ date: Date) -> String {
        timeFormatter.string(from: date)
    }

    /// Title of the separator between days: "Today", "Yesterday", or the date.
    static func daySeparator(_ date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return NSLocalizedString("today", comment: "")
        }
        if calendar.isDateInYesterday(date) {
            return NSLocalizedString("chat_yesterday", comment: "")
        }
        return dayFormatter.string(from: date)
    }

    /// Stable key for grouping messages into day buckets.
    static func dayKey(_ date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }

    /// Opening line from support, chosen by time of day to match the greeting a person
    /// would actually type. Cut-offs follow common usage: morning until noon, afternoon
    /// until 18:00, evening after.
    static func greeting(at date: Date = Date()) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        switch hour {
        case 0..<12:
            return NSLocalizedString("chat_greeting_morning", comment: "")
        case 12..<18:
            return NSLocalizedString("chat_greeting_afternoon", comment: "")
        default:
            return NSLocalizedString("chat_greeting_evening", comment: "")
        }
    }
}

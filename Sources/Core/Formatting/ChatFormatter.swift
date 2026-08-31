//
//  ChatFormatter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Date and time strings for the support thread.
enum ChatFormatter {
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

    static func time(_ date: Date) -> String {
        timeFormatter.string(from: date)
    }

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

    static func dayKey(_ date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }

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

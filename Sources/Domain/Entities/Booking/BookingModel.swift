//
//  BookingModel.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// A confirmed booking, as read back from storage.
struct BookingModel {
    let id: String
    let tourId: String
    let tourTitle: String
    let imageURL: String?
    let reference: String
    let airfield: String
    let date: Date
    let departureTime: String
    let durationMinutes: Int?
    let passengers: Int
    let amount: Decimal
    let currencyCode: String
    let cardLast4: String?
    let cardBrand: CardBrand?
    let status: BookingStatus
    let createdAt: Date
}

enum BookingStatus: String, Codable {
    case paid
    case cancelled
}

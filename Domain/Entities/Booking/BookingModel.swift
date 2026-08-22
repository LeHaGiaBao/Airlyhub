//
//  BookingModel.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// A confirmed booking, as read back from storage.
///
/// The tour's own fields (`tourTitle`, `airfield`, `amount`, …) are denormalized
/// onto the record rather than looked up by `tourId` at read time — the same
/// choice `ChatConversationModel` makes for its last message. A ticket has to keep
/// reading correctly even if the catalog record it came from changes price or is
/// removed later.
struct BookingModel {
    let id: String
    let tourId: String
    let tourTitle: String
    let imageURL: String?
    /// Short booking reference shown as the ticket's id and barcode payload —
    /// "673-843". Distinct from `id`: this is a small human-facing label generated
    /// at booking time, `id` is whatever the store assigns (a Firestore auto-id).
    let reference: String
    let airfield: String
    /// Day of departure. A tour has no date to pick on the parameters card, so this
    /// defaults to the booking date for one — see `TourDetailSelection.date`.
    let date: Date
    /// One of the fixed departure slots — "9:00" — not a component of `date`,
    /// since the catalog offers a handful of fixed times rather than an arbitrary
    /// one worth storing as structured time.
    let departureTime: String
    /// Nil for a flight, which has no duration to choose — mirrors
    /// `TourDetailModel.durations` being empty there.
    let durationMinutes: Int?
    let passengers: Int
    let amount: Decimal
    let currencyCode: String
    /// Card the booking was paid with. Both nil when paid without saving/reusing a
    /// card — the CVV is never stored, so there is nothing else to keep.
    let cardLast4: String?
    let cardBrand: CardBrand?
    let status: BookingStatus
    let createdAt: Date
}

enum BookingStatus: String, Codable {
    case paid
    case cancelled
}

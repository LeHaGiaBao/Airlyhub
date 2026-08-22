//
//  TicketModel.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// One booked flight, carrying everything both the list row and the detail screen
/// need. `SmallTicketModel` stays the row's own display model — see the mapper
/// below — so the cell keeps rendering exactly what it did before.
///
/// Dates, times and the price are finished strings rather than `Date`/`Decimal` —
/// this is still the display model, not the record. `BookingModel` is the typed
/// one now that a booking API exists; see the mapper below for where the
/// formatting happens.
struct TicketModel {
    /// Booking reference — "673-843". Doubles as the screen title and the barcode's
    /// payload, which is why it is also what the row shows.
    let id: String
    let title: String
    /// Absolute URL of the aircraft photo, hosted outside the project for the same
    /// reason the catalog's artwork is — see `TourModel.imageURL`.
    let imageURL: String?
    let priceText: String
    let dateText: String
    let airfield: String
    let departureTimeText: String
    let durationText: String
}

// MARK: - Mapping
extension TicketModel {
    /// "—" stands in for a flight's duration, which has nothing to show: only a
    /// tour has a length to choose, so `durationMinutes` is nil for a flight
    /// booking — see `BookingModel.durationMinutes`.
    init(booking: BookingModel) {
        self.init(
            id: booking.reference,
            title: booking.tourTitle,
            imageURL: booking.imageURL,
            priceText: TourFormatter.price(booking.amount, currencyCode: booking.currencyCode),
            dateText: TicketFormatter.date(booking.date),
            airfield: booking.airfield,
            departureTimeText: booking.departureTime,
            durationText: booking.durationMinutes.map(TicketFormatter.duration) ?? "—"
        )
    }
}

extension SmallTicketModel {
    /// The subtitle is composed here rather than stored, so the row and the detail
    /// screen cannot drift apart on the same two facts.
    init(ticket: TicketModel) {
        self.init(
            id: ticket.id,
            title: ticket.title,
            subtitle: "\(TourFormatter.airfield(ticket.airfield)), \(ticket.dateText)",
            priceText: ticket.priceText
        )
    }
}

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
/// Dates, times and the price are finished strings rather than `Date`/`Decimal`.
/// That is a stand-in for a backend: there is no booking API yet, and a record read
/// from one would carry real values that this screen would then format. When that
/// lands, the formatting moves into a `TicketFormatter` and these become typed.
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

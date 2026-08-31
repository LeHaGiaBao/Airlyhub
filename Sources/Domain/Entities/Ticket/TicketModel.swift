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
struct TicketModel {
    let id: String
    let title: String
    let imageURL: String?
    let priceText: String
    let dateText: String
    let airfield: String
    let departureTimeText: String
    let durationText: String
}

extension TicketModel {
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
    init(ticket: TicketModel) {
        self.init(
            id: ticket.id,
            title: ticket.title,
            subtitle: "\(TourFormatter.airfield(ticket.airfield)), \(ticket.dateText)",
            priceText: ticket.priceText
        )
    }
}

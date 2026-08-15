//
//  MyTicketsEntity.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import Foundation

/// Tickets grouped under a date heading.
///
/// Holds whole `TicketModel` records rather than the row's `SmallTicketModel`: the
/// list is where a tap starts, and the detail screen needs the full record. The row
/// keeps rendering its own display model — the view maps each record as it dequeues.
struct MyTicketsSection {
    let title: String
    let tickets: [TicketModel]
}

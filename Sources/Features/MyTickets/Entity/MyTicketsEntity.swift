//
//  MyTicketsEntity.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import Foundation

/// Tickets grouped under a date heading.
struct MyTicketsSection {
    let title: String
    let tickets: [TicketModel]
}

enum MyTicketsViewState {
    case loading
    case loaded([MyTicketsSection])
    case failed(String)
}

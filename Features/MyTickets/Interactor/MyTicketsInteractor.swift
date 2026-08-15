//
//  MyTicketsInteractor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import Foundation

final class MyTicketsInteractor: MyTicketsInteractorProtocol {
    /// One section per record, matching the grouping the screen was built with.
    /// The records themselves now come from `TicketMockData` instead of being
    /// written out here, so a row and the ticket it opens cannot disagree.
    func fetchMyTickets() -> [MyTicketsSection] {
        TicketMockData.all.map { ticket in
            MyTicketsSection(
                title: NSLocalizedString("today", comment: ""),
                tickets: [ticket]
            )
        }
    }
}

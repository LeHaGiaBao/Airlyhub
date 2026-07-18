//
//  MyTicketsInteractor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import Foundation

final class MyTicketsInteractor: MyTicketsInteractorProtocol {
    func fetchMyTickets() -> [MyTicketsSection] {
        return [
            MyTicketsSection(
                title: NSLocalizedString("today", comment: ""),
                tickets: [
                    SmallTicketModel(id: "673-843",
                                     title: "Cessna 172 familiarization flight from Kronstadt",
                                     subtitle: "Airfield: Bychye Polye, July 30th",
                                     priceText: "10 000 ₽"
                    )
                ]
            ),
            MyTicketsSection(
                title: NSLocalizedString("today", comment: ""),
                tickets: [
                    SmallTicketModel(id: "673-843",
                                     title: "Cessna 172 familiarization flight from Kronstadt",
                                     subtitle: "Airfield: Bychye Polye, July 30th",
                                     priceText: "10 000 ₽"
                    )
                ]
            ),
            MyTicketsSection(
                title: NSLocalizedString("today", comment: ""),
                tickets: [
                    SmallTicketModel(id: "673-843",
                                     title: "Cessna 172 familiarization flight from Kronstadt",
                                     subtitle: "Airfield: Bychye Polye, July 30th",
                                     priceText: "10 000 ₽"
                    )
                ]
            ),
        ]
    }
}

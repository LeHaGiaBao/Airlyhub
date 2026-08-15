//
//  TicketMockData.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Booked tickets, written out in Swift — the same stand-in-for-a-backend approach
/// as `TourMockData`, and for the same reasons: no server, and source that cannot
/// go missing from the bundle or fail to decode.
///
/// Three distinct records rather than one repeated, so opening a row actually shows
/// that row's ticket. Artwork reuses the catalog's seeds, which means a tour the
/// user browsed and the ticket they hold for it share a cached image.
enum TicketMockData {
    static let all: [TicketModel] = [
        TicketModel(
            id: "673-843",
            title: "Cessna 172 familiarization flight from Kronstadt",
            imageURL: "https://picsum.photos/seed/airly-tour-01/800/500",
            priceText: "4 000 ₽",
            dateText: "30.07.2022",
            airfield: "Bychye Polye",
            departureTimeText: "13:30",
            durationText: "50 min"
        ),
        TicketModel(
            id: "902-118",
            title: "Cetus 900 airplane flight from Kronstadt",
            imageURL: "https://picsum.photos/seed/airly-tour-02/800/500",
            priceText: "7 200 ₽",
            dateText: "12.08.2022",
            airfield: "Selzo",
            departureTimeText: "09:15",
            durationText: "35 min"
        ),
        TicketModel(
            id: "415-267",
            title: "Extreme flight over the Gulf of Finland",
            imageURL: "https://picsum.photos/seed/airly-tour-04/800/500",
            priceText: "12 000 ₽",
            dateText: "03.09.2022",
            airfield: "Bychye Polye",
            departureTimeText: "16:45",
            durationText: "1 h 10 min"
        )
    ]
}

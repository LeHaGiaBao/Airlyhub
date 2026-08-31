//
//  BookingDraft.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// What "Book" on the detail screen hands to Checkout — everything about the trip,
/// nothing about how it was paid for yet.
struct BookingDraft {
    let tourId: String
    let tourTitle: String
    let imageURL: String?
    let airfield: String
    let date: Date
    let departureTime: String
    let durationMinutes: Int?
    let passengers: Int
    let amount: Decimal
    let currencyCode: String
}

extension BookingDraft {
    init(detail: TourDetailModel, selection: TourDetailSelection) {
        let durationIndex = detail.durations.indices.contains(selection.durationIndex)
            ? selection.durationIndex : 0
        let timeIndex = detail.departureTimes.indices.contains(selection.departureTimeIndex)
            ? selection.departureTimeIndex : 0
        let selectedDuration = detail.durations.indices.contains(durationIndex)
            ? detail.durations[durationIndex] : nil

        self.init(
            tourId: detail.id,
            tourTitle: detail.title,
            imageURL: detail.imageURL,
            airfield: detail.airfield ?? "",
            date: selection.date,
            departureTime: detail.departureTimes.indices.contains(timeIndex)
                ? detail.departureTimes[timeIndex] : "",
            durationMinutes: selectedDuration?.minutes,
            passengers: min(selection.passengers, detail.maxPassengers),
            amount: selectedDuration?.price ?? detail.price,
            currencyCode: detail.currencyCode
        )
    }
}

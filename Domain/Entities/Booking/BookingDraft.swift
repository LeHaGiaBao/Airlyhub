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
///
/// Built once, by `TourDetailPresenter`, from the same `TourDetailModel` +
/// `TourDetailSelection` pair `TourDetailViewModel` renders from — so the price and
/// the chosen duration/time a user booked are exactly what they last saw on screen,
/// not a re-derivation that could disagree with it.
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

// MARK: - Mapping
extension BookingDraft {
    /// Resolves the same clamped indices and effective price
    /// `TourDetailViewModel.init(detail:selection:isFavorite:)` does, so a booking
    /// always matches exactly what the user last saw rendered on the detail screen.
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

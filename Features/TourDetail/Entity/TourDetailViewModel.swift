//
//  TourDetailViewModel.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// What `TourDetailViewController` renders. Rebuilt from `TourDetailModel` and the
/// current `TourDetailSelection` on every change, the same way
/// `SearchResultsContext` re-derives its summary from `criteria` — one assignment
/// keeps the header, the price and the button in step instead of three properties
/// that could individually go stale.
///
/// A tour and a flight render through one screen, not two — every field that only
/// one of them uses is `nil` or empty, which is what lets the view hide a whole
/// section instead of a feature switch choosing between two layouts. See
/// `TourDetailModel` for where that split originates.
struct TourDetailViewModel {
    let id: String
    let title: String
    /// Nil hides the paragraph under the title — a flight has none.
    let description: String?
    let imageURL: String?
    let ratingText: String?
    let heroBadges: [String]
    let isFavorite: Bool

    /// Trip-level place name for the parameters card's first row — shown only for
    /// a tour. Nil for a flight, whose first row is `dateText` instead.
    let originText: String?
    /// Nil for a tour, which has nowhere to pick a date — every departure is "now".
    /// Left as a `Date` rather than formatted text so `FlightsDateRowView` can
    /// format and re-format it itself exactly as it does on the search form.
    let date: Date?
    let maxPassengers: Int
    let passengers: Int

    /// Empty hides "Flight duration" — only a tour offers a choice of length.
    let durationTitles: [String]
    let selectedDurationIndex: Int
    /// "Start of flight" for a tour, "Departure time" for a flight — the row always
    /// shows, only its heading changes.
    let departureSectionTitle: String
    let departureTimeTitles: [String]
    let selectedDepartureTimeIndex: Int

    /// "Airfield: Bychye Polye" — the row atop the route timeline.
    let airfieldText: String?
    let routeWaypoints: [String]

    let pilot: PilotModel
    /// Only the first `previewReviewLimit` reviews — the rest live behind the
    /// "All reviews" button, which routes to the full list from `TourDetailModel`
    /// rather than from here.
    let reviews: [TourReviewModel]

    /// "Book for 10 000 ₽" — already carries the currently selected duration's
    /// price, or the flight's flat price when there is no duration to choose.
    let bookButtonText: String
}

// MARK: - Mapping
extension TourDetailViewModel {
    /// How many reviews the detail screen previews before deferring to the full
    /// list. Two is what the design shows under "Customer reviews".
    private static let previewReviewLimit = 2

    init(detail: TourDetailModel, selection: TourDetailSelection, isFavorite: Bool) {
        var badges: [String] = []
        if let airfield = detail.airfield, !airfield.isEmpty {
            badges.append(TourFormatter.airfield(airfield))
        }
        badges.append(TourFormatter.passengers(detail.maxPassengers))

        let isTour = detail.type == .tour
        let durationIndex = detail.durations.indices.contains(selection.durationIndex)
            ? selection.durationIndex : 0
        let timeIndex = detail.departureTimes.indices.contains(selection.departureTimeIndex)
            ? selection.departureTimeIndex : 0

        let bookPrice = detail.durations[safe: durationIndex]?.price ?? detail.price

        self.init(
            id: detail.id,
            title: detail.title,
            description: detail.description,
            imageURL: detail.imageURL,
            ratingText: TourFormatter.rating(detail.rating),
            heroBadges: badges,
            isFavorite: isFavorite,
            originText: isTour ? detail.originCity : nil,
            date: isTour ? nil : selection.date,
            maxPassengers: detail.maxPassengers,
            passengers: min(selection.passengers, detail.maxPassengers),
            durationTitles: detail.durations.map {
                String(format: NSLocalizedString("tour_detail_duration_minutes", comment: ""), $0.minutes)
            },
            selectedDurationIndex: durationIndex,
            departureSectionTitle: NSLocalizedString(
                isTour ? "tour_detail_start_of_flight" : "tour_detail_departure_time",
                comment: ""
            ),
            departureTimeTitles: detail.departureTimes,
            selectedDepartureTimeIndex: timeIndex,
            airfieldText: detail.airfield.map(TourFormatter.airfield),
            routeWaypoints: detail.routeWaypoints,
            pilot: detail.pilot,
            reviews: Array(detail.reviews.prefix(Self.previewReviewLimit)),
            bookButtonText: String(
                format: NSLocalizedString("tour_detail_book_button", comment: ""),
                TourFormatter.price(bookPrice, currencyCode: detail.currencyCode)
            )
        )
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

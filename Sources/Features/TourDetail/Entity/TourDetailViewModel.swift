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
struct TourDetailViewModel {
    let id: String
    let title: String
    let description: String?
    let imageURL: String?
    let ratingText: String?
    let heroBadges: [String]
    let isFavorite: Bool

    let originText: String?
    let date: Date?
    let maxPassengers: Int
    let passengers: Int

    let durationTitles: [String]
    let selectedDurationIndex: Int
    let departureSectionTitle: String
    let departureTimeTitles: [String]
    let selectedDepartureTimeIndex: Int

    let airfieldText: String?
    let routeWaypoints: [String]

    let pilot: PilotModel
    let reviews: [TourReviewModel]

    let bookButtonText: String
}

extension TourDetailViewModel {
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

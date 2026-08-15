//
//  TourCardModel.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// What `TourCardView` renders. Everything is a finished string, so the card does
/// no formatting and no locale work of its own.
///
/// This type is the reason Explore and Flights share one card. Their designs differ
/// in exactly one place — Flights shows a per-passenger price — and that difference
/// is carried here as `priceText` being nil rather than as a second card class.
struct TourCardModel {
    let id: String
    let title: String
    let imageURL: String?
    /// Shown with a star glyph. Nil hides the badge entirely.
    let ratingText: String?
    /// Plain pills after the rating: airfield, seats, and whatever a later record adds.
    let badges: [String]
    /// Nil hides the whole price row — that is the Explore variant.
    let priceText: String?
    let isFavorite: Bool
}

// MARK: - Mapping
extension TourCardModel {
    /// - Parameter showsPrice: pass `false` for the Explore rails, where a tour is
    ///   presented as an experience and the price appears only on the detail screen.
    ///   Defaults to whether the record is a point-to-point flight.
    init(tour: TourModel, isFavorite: Bool = false, showsPrice: Bool? = nil) {
        let showsPrice = showsPrice ?? (tour.type == .flight)

        var badges: [String] = []
        if let airfield = tour.airfield, !airfield.isEmpty {
            badges.append(TourFormatter.airfield(airfield))
        }
        badges.append(TourFormatter.passengers(tour.passengers))

        self.init(
            id: tour.id,
            title: tour.title,
            imageURL: tour.imageURL,
            ratingText: TourFormatter.rating(tour.rating),
            badges: badges,
            priceText: showsPrice
                ? TourFormatter.price(tour.price, currencyCode: tour.currencyCode)
                : nil,
            isFavorite: isFavorite
        )
    }
}

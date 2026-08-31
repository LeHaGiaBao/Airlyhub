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
struct TourCardModel {
    let id: String
    let title: String
    let imageURL: String?
    let ratingText: String?
    let badges: [String]
    let priceText: String?
    let isFavorite: Bool
}

extension TourCardModel {
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

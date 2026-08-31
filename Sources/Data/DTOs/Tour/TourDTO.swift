//
//  TourDTO.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Wire shape of a catalog record — the document body, without its id.
struct TourDTO: Codable {
    let type: String
    let title: String
    let imageURL: String?
    let rating: Double?
    let airfield: String?
    let passengers: Int
    let price: Decimal
    let currency: String
    let originSlug: String
    let destinationSlug: String?
    let tags: [String]?
    let isActive: Bool?

    let description: String?
    let originCity: String?
    let durations: [TourDurationOptionDTO]?
    let departureTimes: [String]?
    let routeWaypoints: [String]?
    let pilot: PilotDTO?
    let reviews: [TourReviewDTO]?
}

struct TourDurationOptionDTO: Codable {
    let minutes: Int
    let price: Decimal
}

struct PilotDTO: Codable {
    let name: String
    let avatarURL: String?
    let rating: Double
    let airplane: String
    let hoursFlown: Int
    let license: String
}

struct TourReviewDTO: Codable {
    let authorName: String
    let authorAvatarURL: String?
    let rating: Int
    let date: Date
    let comment: String
}

extension TourDTO {
    func toDomain(id: String) -> TourModel? {
        guard let type = TourType(rawValue: type) else { return nil }

        return TourModel(
            id: id,
            type: type,
            title: title,
            imageURL: imageURL,
            rating: rating,
            airfield: airfield,
            passengers: passengers,
            price: price,
            currencyCode: currency,
            originSlug: originSlug,
            destinationSlug: destinationSlug,
            tags: tags ?? []
        )
    }

    func toDetailDomain(id: String) -> TourDetailModel? {
        guard let type = TourType(rawValue: type), let pilot else { return nil }

        return TourDetailModel(
            id: id,
            type: type,
            title: title,
            description: description,
            imageURL: imageURL,
            rating: rating,
            airfield: airfield,
            originCity: originCity ?? airfield ?? title,
            maxPassengers: passengers,
            price: price,
            currencyCode: currency,
            durations: (durations ?? []).map { $0.toDomain() },
            departureTimes: departureTimes ?? [],
            routeWaypoints: routeWaypoints ?? [],
            pilot: pilot.toDomain(),
            reviews: (reviews ?? []).enumerated().map { index, review in
                review.toDomain(id: "\(id)_review_\(index)")
            }
        )
    }
}

extension TourDurationOptionDTO {
    func toDomain() -> TourDurationOption {
        TourDurationOption(minutes: minutes, price: price)
    }
}

extension PilotDTO {
    func toDomain() -> PilotModel {
        PilotModel(
            name: name,
            avatarURL: avatarURL,
            rating: rating,
            airplane: airplane,
            hoursFlown: hoursFlown,
            license: license
        )
    }
}

extension TourReviewDTO {
    func toDomain(id: String) -> TourReviewModel {
        TourReviewModel(
            id: id,
            authorName: authorName,
            authorAvatarURL: authorAvatarURL,
            rating: rating,
            date: date,
            comment: comment
        )
    }
}

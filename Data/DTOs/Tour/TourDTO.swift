//
//  TourDTO.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Wire shape of a catalog record — the document body, without its id.
///
/// Used only by `TourService`, which is not currently wired up: the app renders
/// from `TourMockData`, which is already `TourModel` and needs no decoding. Kept
/// as plain `Codable` with no Firestore attributes so it stays readable as a
/// description of the document shape.
///
/// The id lives outside the body, matching `CardDTO`: Firestore documents carry
/// their key in `documentID`, and duplicating it as a field would leave two copies
/// free to disagree.
struct TourDTO: Codable {
    let type: String
    let title: String
    let imageURL: String?
    let rating: Double?
    let airfield: String?
    let passengers: Int
    /// `Decimal` rather than `Double` so arithmetic downstream stays exact. Catalog
    /// prices are whole units, which `JSONDecoder` reproduces faithfully; if
    /// fractional prices ever appear, encode them as minor units (an `Int` of
    /// kopeks/cents) instead of trusting the JSON number.
    let price: Decimal
    let currency: String
    let originSlug: String
    let destinationSlug: String?
    let tags: [String]?
    let isActive: Bool?

    /// Everything below is read only by `toDetailDomain`, never by `toDomain` — a
    /// search or a popular-rail fetch decodes the same document but leaves these
    /// nil rather than paying to populate fields the card never shows.
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

// MARK: - Mapping
extension TourDTO {
    /// - Parameter id: the Firestore `documentID`, or the seed file's object key.
    ///
    /// Nil when the record is unusable — an unknown `type` most likely means the
    /// client is older than the catalog, and one bad row shouldn't blank the list.
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

    /// - Parameter id: the Firestore `documentID`.
    ///
    /// Nil when `pilot` is absent — every other detail field degrades to an empty
    /// section, but a tour with no pilot at all reads as not yet finished in the
    /// console rather than as a valid record with a blank card.
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
            // Reviews are an array field, not a subcollection, so an element has no
            // id of its own — the index stands in, the same way the mock catalog's
            // `TourReviewModel.id` values are just authored labels.
            reviews: (reviews ?? []).enumerated().map { index, review in
                review.toDomain(id: "\(id)_review_\(index)")
            }
        )
    }
}

// MARK: - Nested mapping
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

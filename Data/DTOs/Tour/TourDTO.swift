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
}

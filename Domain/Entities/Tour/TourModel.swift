//
//  TourModel.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// One catalog record, as stored. The display-side counterpart is `TourCardModel`,
/// which is what the card actually renders — see the mapper there.
struct TourModel {
    let id: String
    let type: TourType
    let title: String
    /// Absolute URL of the artwork, hosted outside the project. Deliberately not a
    /// Realtime Database reference like avatars are: a scrolling list of base64
    /// blobs would blow past the 1 MiB document limit and the free plan's egress.
    let imageURL: String?
    /// 0…5, absent on a record with no reviews yet.
    let rating: Double?
    let airfield: String?
    /// Seats the aircraft carries. Used both as a card badge and as the filter for
    /// the party size entered on the search form.
    let passengers: Int
    let price: Decimal
    /// ISO 4217, e.g. "RUB". Stored per record because the catalog is priced in
    /// the operator's currency, not the device's.
    let currencyCode: String
    let originSlug: String
    /// Absent for `.tour`, which departs and returns to the same airfield.
    let destinationSlug: String?
    /// Free-form markers used for curated rails; `popular` drives the Explore carousel.
    let tags: [String]
}

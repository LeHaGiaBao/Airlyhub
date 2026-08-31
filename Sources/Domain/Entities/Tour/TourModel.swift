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
    let imageURL: String?
    let rating: Double?
    let airfield: String?
    let passengers: Int
    let price: Decimal
    let currencyCode: String
    let originSlug: String
    let destinationSlug: String?
    let tags: [String]
}

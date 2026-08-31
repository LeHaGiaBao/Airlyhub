//
//  TourDetailModel.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// The full record behind a tour or flight's detail screen.
struct TourDetailModel {
    let id: String
    let type: TourType
    let title: String
    let description: String?
    let imageURL: String?
    let rating: Double?
    let airfield: String?
    let originCity: String
    let maxPassengers: Int
    let price: Decimal
    let currencyCode: String
    let durations: [TourDurationOption]
    let departureTimes: [String]
    let routeWaypoints: [String]
    let pilot: PilotModel
    let reviews: [TourReviewModel]
}

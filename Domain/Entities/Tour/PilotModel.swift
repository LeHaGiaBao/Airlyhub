//
//  PilotModel.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// The "Pilot information" card on a tour's detail screen.
///
/// Every tour and flight record in the catalog is flown by an operator's pilot,
/// not chosen per booking, so this is embedded on `TourDetailModel` rather than
/// looked up separately.
struct PilotModel {
    let name: String
    let avatarURL: String?
    /// 0…5. Unlike `TourModel.rating`, a pilot always has one — the catalog seeds
    /// every record with its pilot's standing rating.
    let rating: Double
    let airplane: String
    let hoursFlown: Int
    let license: String
}

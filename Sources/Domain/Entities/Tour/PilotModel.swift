//
//  PilotModel.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// The "Pilot information" card on a tour's detail screen.
struct PilotModel {
    let name: String
    let avatarURL: String?
    let rating: Double
    let airplane: String
    let hoursFlown: Int
    let license: String
}

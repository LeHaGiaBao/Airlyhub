//
//  TourDurationOption.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// One pill in the detail screen's "Flight duration" row — a tour's price depends
/// on how long it runs, so each length carries its own price rather than the
/// screen scaling one base price by a multiplier.
///
/// Point-to-point flights have no such choice — their record's `durations` is
/// empty and the row is hidden; see `TourDetailModel.durations`.
struct TourDurationOption: Equatable {
    let minutes: Int
    let price: Decimal
}

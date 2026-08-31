//
//  TourDetailSelection.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// What the user has picked on the parameters card, kept apart from the record
/// itself so a pill tap or a stepper nudge is a single assignment rather than a
/// re-fetch — the same split `SearchResultsContext` draws between `criteria` and
/// the query it derives.
struct TourDetailSelection {
    var durationIndex: Int = 0
    var departureTimeIndex: Int = 0
    var passengers: Int = 1
    var date: Date = Date()
}

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
    /// Index into `TourDetailModel.durations`. Meaningless for a flight, whose
    /// `durations` is empty — the presenter never reads it in that case.
    var durationIndex: Int = 0
    /// Index into `TourDetailModel.departureTimes`.
    var departureTimeIndex: Int = 0
    /// Clamped to `TourDetailModel.maxPassengers` by whoever sets it.
    var passengers: Int = 1
    /// Flight only — a tour departs "now" and has no date to pick. Defaults to
    /// today, matching a fresh `FlightsDateRowView`.
    var date: Date = Date()
}

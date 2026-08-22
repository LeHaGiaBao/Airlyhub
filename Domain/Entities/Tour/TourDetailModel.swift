//
//  TourDetailModel.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// The full record behind a tour or flight's detail screen.
///
/// `TourModel` stays the catalog's list-facing shape — everything a card needs and
/// nothing more. This is the same record's full body, fetched only once a user taps
/// into it, which is why it is a separate type rather than `TourModel` growing these
/// fields for every row a search returns.
///
/// Air tours and point-to-point flights render through one screen, not two — see
/// the `TourDetailViewModel` mapper in `Features/TourDetail`. Every field that only
/// one of the two uses is optional or an array that the other leaves empty, so the
/// screen hides a whole section rather than a feature switch choosing between two
/// layouts.
struct TourDetailModel {
    let id: String
    let type: TourType
    let title: String
    /// Shown under the title. Nil hides the paragraph entirely — flights have none.
    let description: String?
    let imageURL: String?
    let rating: Double?
    let airfield: String?
    /// The trip-level place name shown on the parameters card — "St Petersburg",
    /// not the specific `airfield` the route section names. A tour departs and
    /// returns to that one city; a flight's card shows a date picker in this row
    /// instead, so the field goes unused there.
    let originCity: String
    /// Seats the aircraft carries — the upper bound the passengers stepper enforces.
    let maxPassengers: Int
    /// What "Book for" shows when `durations` is empty, i.e. for a flight. A tour's
    /// price instead comes from whichever `TourDurationOption` is selected.
    let price: Decimal
    let currencyCode: String
    /// Empty hides "Flight duration" — a flight's length isn't a choice, only a
    /// tour's is. Non-empty for a tour; the first option is selected by default.
    let durations: [TourDurationOption]
    /// Finished strings ("7:00") for the "Start of flight" / "Departure time" pills.
    let departureTimes: [String]
    /// Stops between the airfield and, for a flight, its destination — "Kronstadt,
    /// Gulf of Finland, Forts, Dam" for a tour, just the destination city for a
    /// flight. The airfield itself is `airfield` above, shown as the row atop this
    /// list rather than as its first entry.
    let routeWaypoints: [String]
    let pilot: PilotModel
    let reviews: [TourReviewModel]
}

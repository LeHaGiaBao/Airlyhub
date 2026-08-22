//
//  TourMockData.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// The tour catalog, written out in Swift.
///
/// This is a pet-project stand-in for a backend: there is no server and no bundled
/// JSON, so the records live in the binary and every search returns them. Being
/// source rather than a resource means the list cannot go missing from the bundle
/// and cannot fail to decode — two ways a mock can quietly render nothing.
///
/// Replace the whole type when a real catalog exists; nothing outside
/// `MockTourRepository` refers to it.
enum TourMockData {
    static let all: [TourModel] = [
        TourModel(
            id: "tour_kronstadt_cessna172_selzo",
            type: .tour,
            title: "Cessna 172 familiarization flight from Kronstadt",
            imageURL: "https://picsum.photos/seed/airly-tour-01/800/500",
            rating: 4.7,
            airfield: "Selzo",
            passengers: 4,
            price: 5400,
            currencyCode: "RUB",
            originSlug: "st_petersburg",
            destinationSlug: nil,
            tags: ["popular"]
        ),
        TourModel(
            id: "tour_kronstadt_cetus900",
            type: .tour,
            title: "Cetus 900 airplane flight from Kronstadt",
            imageURL: "https://picsum.photos/seed/airly-tour-02/800/500",
            rating: 4.9,
            airfield: "Bychye Polye",
            passengers: 1,
            price: 7200,
            currencyCode: "RUB",
            originSlug: "st_petersburg",
            destinationSlug: nil,
            tags: []
        ),
        TourModel(
            id: "tour_kronstadt_cessna172_bychye",
            type: .tour,
            title: "Cessna 172 familiarization flight from Kronstadt",
            imageURL: "https://picsum.photos/seed/airly-tour-03/800/500",
            rating: 4.8,
            airfield: "Bychye Polye",
            passengers: 3,
            price: 6100,
            currencyCode: "RUB",
            originSlug: "st_petersburg",
            destinationSlug: nil,
            tags: []
        ),
        TourModel(
            id: "tour_gulf_of_finland_extreme",
            type: .tour,
            title: "Extreme flight over the Gulf of Finland",
            imageURL: "https://picsum.photos/seed/airly-tour-04/800/500",
            rating: 4.6,
            airfield: "Selzo",
            passengers: 2,
            price: 9800,
            currencyCode: "RUB",
            originSlug: "st_petersburg",
            destinationSlug: nil,
            tags: ["popular", "extreme"]
        ),
        TourModel(
            id: "tour_over_the_city_panorama",
            type: .tour,
            title: "Over the city: St. Petersburg panorama",
            imageURL: "https://picsum.photos/seed/airly-tour-05/800/500",
            rating: 4.9,
            airfield: "Pulkovo",
            passengers: 3,
            price: 8300,
            currencyCode: "RUB",
            originSlug: "st_petersburg",
            destinationSlug: nil,
            tags: ["popular"]
        ),
        TourModel(
            id: "tour_for_two_peterhof_sunset",
            type: .tour,
            title: "For two: sunset flight over Peterhof",
            imageURL: "https://picsum.photos/seed/airly-tour-06/800/500",
            rating: 5.0,
            airfield: "Selzo",
            passengers: 2,
            price: 12500,
            currencyCode: "RUB",
            originSlug: "st_petersburg",
            destinationSlug: nil,
            tags: ["popular"]
        ),
        TourModel(
            id: "tour_yak52_aerobatic",
            type: .tour,
            title: "Yak-52 aerobatic experience",
            imageURL: "https://picsum.photos/seed/airly-tour-07/800/500",
            rating: 4.5,
            airfield: "Gorskaya",
            passengers: 1,
            price: 11000,
            currencyCode: "RUB",
            originSlug: "st_petersburg",
            destinationSlug: nil,
            tags: ["extreme"]
        ),
        TourModel(
            id: "tour_ladoga_seaplane",
            type: .tour,
            title: "Seaplane landing on Lake Ladoga",
            imageURL: "https://picsum.photos/seed/airly-tour-08/800/500",
            rating: 4.4,
            airfield: "Ladoga",
            passengers: 4,
            price: 14200,
            currencyCode: "RUB",
            originSlug: "st_petersburg",
            destinationSlug: nil,
            tags: []
        ),
        TourModel(
            id: "flight_nsk_baikal_01",
            type: .flight,
            title: "Novosibirsk - Baikal",
            imageURL: "https://picsum.photos/seed/airly-flight-01/800/500",
            rating: 4.9,
            airfield: "Krasnaya Polyana",
            passengers: 4,
            price: 2000,
            currencyCode: "RUB",
            originSlug: "novosibirsk",
            destinationSlug: "baikal",
            tags: ["popular"]
        ),
        TourModel(
            id: "flight_nsk_baikal_02",
            type: .flight,
            title: "Novosibirsk - Baikal",
            imageURL: "https://picsum.photos/seed/airly-flight-02/800/500",
            rating: 4.9,
            airfield: "Krasnaya Polyana",
            passengers: 4,
            price: 2000,
            currencyCode: "RUB",
            originSlug: "novosibirsk",
            destinationSlug: "baikal",
            tags: []
        ),
        TourModel(
            id: "flight_nsk_baikal_03",
            type: .flight,
            title: "Novosibirsk - Baikal",
            imageURL: "https://picsum.photos/seed/airly-flight-03/800/500",
            rating: 4.7,
            airfield: "Krasnaya Polyana",
            passengers: 6,
            price: 2400,
            currencyCode: "RUB",
            originSlug: "novosibirsk",
            destinationSlug: "baikal",
            tags: []
        ),
        TourModel(
            id: "flight_nsk_baikal_04",
            type: .flight,
            title: "Novosibirsk - Baikal",
            imageURL: "https://picsum.photos/seed/airly-flight-04/800/500",
            rating: 4.8,
            airfield: "Yeltsovka",
            passengers: 2,
            price: 3200,
            currencyCode: "RUB",
            originSlug: "novosibirsk",
            destinationSlug: "baikal",
            tags: []
        ),
        TourModel(
            id: "flight_nsk_altai_01",
            type: .flight,
            title: "Novosibirsk - Altai",
            imageURL: "https://picsum.photos/seed/airly-flight-05/800/500",
            rating: 4.6,
            airfield: "Krasnaya Polyana",
            passengers: 4,
            price: 1800,
            currencyCode: "RUB",
            originSlug: "novosibirsk",
            destinationSlug: "altai",
            tags: ["popular"]
        ),
        TourModel(
            id: "flight_nsk_krasnoyarsk_01",
            type: .flight,
            title: "Novosibirsk - Krasnoyarsk",
            imageURL: "https://picsum.photos/seed/airly-flight-06/800/500",
            rating: 4.5,
            airfield: "Yeltsovka",
            passengers: 3,
            price: 1500,
            currencyCode: "RUB",
            originSlug: "novosibirsk",
            destinationSlug: "krasnoyarsk",
            tags: []
        )
    ]
}

// MARK: - Detail
extension TourMockData {
    /// Builds the detail screen's record from the matching list record plus a
    /// handful of shared, catalog-wide content.
    ///
    /// The list fields (`title`, `price`, `airfield`, …) come straight from `all`;
    /// everything the list never needed — description, route, pilot, reviews — is
    /// synthesized here rather than authored per record, the same trade-off `all`
    /// itself documents: this is a pet project's stand-in for a backend, and a
    /// generated-but-consistent record beats fourteen hand-written ones for the
    /// same reason a filter that always matches beats one that mostly returns
    /// nothing while the UI is being built.
    static func detail(id: String) -> TourDetailModel? {
        guard let tour = all.first(where: { $0.id == id }) else { return nil }
        let isTour = tour.type == .tour

        return TourDetailModel(
            id: tour.id,
            type: tour.type,
            title: tour.title,
            description: isTour ? description(for: tour) : nil,
            imageURL: tour.imageURL,
            rating: tour.rating,
            airfield: tour.airfield,
            originCity: originCity(for: tour),
            maxPassengers: tour.passengers,
            price: tour.price,
            currencyCode: tour.currencyCode,
            durations: isTour ? durations(basePrice: tour.price) : [],
            departureTimes: departureTimes,
            routeWaypoints: isTour ? tourWaypoints : flightWaypoints(for: tour),
            pilot: pilot,
            reviews: reviews
        )
    }

    /// Same operating schedule shown on both screens.
    private static let departureTimes = ["7:00", "9:00", "11:00", "13:00", "15:00"]

    /// Every `.tour` record departs from an airfield around St Petersburg and flies
    /// the same local excursion, so one static route serves all eight.
    private static let tourWaypoints = ["Kronstadt", "Gulf of Finland", "Forts", "Dam"]

    /// The mock catalog only ever uses two origin slugs, so a display name for each
    /// is simpler than a general slug-to-name reverser — which `TourSlug` explicitly
    /// says cannot exist, since the mapping the other direction is many-to-one.
    private static let originDisplayNames = [
        "st_petersburg": "St Petersburg",
        "novosibirsk": "Novosibirsk"
    ]

    private static func originCity(for tour: TourModel) -> String {
        originDisplayNames[tour.originSlug] ?? tour.airfield ?? tour.title
    }

    /// A flight's route is just its destination — the title is already written as
    /// "Origin - Destination", so the waypoint reuses that instead of a second
    /// place-name table.
    private static func flightWaypoints(for tour: TourModel) -> [String] {
        guard let destination = tour.title.components(separatedBy: " - ").last,
              destination != tour.title else {
            return []
        }
        return [destination]
    }

    private static func description(for tour: TourModel) -> String {
        String(format: NSLocalizedString("tour_detail_description", comment: ""),
               tour.airfield ?? tour.title)
    }

    private static let durationMinutes = [20, 35, 40, 50, 60]

    /// Scales the record's own price across the standard set of lengths, rounded to
    /// the nearest 100 so the pills never show an odd fraction.
    private static func durations(basePrice: Decimal) -> [TourDurationOption] {
        durationMinutes.map { minutes -> TourDurationOption in
            let scaled = basePrice * Decimal(minutes) / Decimal(35)
            return TourDurationOption(minutes: minutes, price: roundedToHundred(scaled))
        }
    }

    private static func roundedToHundred(_ value: Decimal) -> Decimal {
        let handler = NSDecimalNumberHandler(
            roundingMode: .plain,
            scale: -2,
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: false
        )
        return (value as NSDecimalNumber).rounding(accordingToBehavior: handler) as Decimal
    }

    /// The catalog's one operator flies everything in it, so every record shares
    /// this pilot rather than the mock inventing a roster no screen distinguishes.
    private static let pilot = PilotModel(
        name: "Oleg Samsonov",
        avatarURL: "https://i.pravatar.cc/150?u=airly-pilot-oleg",
        rating: 5.0,
        airplane: "Cessna 172",
        hoursFlown: 1250,
        license: NSLocalizedString("pilot_license_cpl", comment: "")
    )

    /// Two canned reviews reused on every record — there is no review backend yet,
    /// so a shared pool stands in the same way `pilot` does.
    private static let reviews: [TourReviewModel] = [
        TourReviewModel(
            id: "review_ivan",
            authorName: "Ivan",
            authorAvatarURL: "https://i.pravatar.cc/150?u=airly-review-ivan",
            rating: 5,
            date: DateComponents(calendar: .current, year: 2022, month: 5, day: 21).date ?? Date(),
            comment: NSLocalizedString("tour_review_ivan", comment: "")
        ),
        TourReviewModel(
            id: "review_alexander",
            authorName: "Alexander",
            authorAvatarURL: "https://i.pravatar.cc/150?u=airly-review-alexander",
            rating: 4,
            date: DateComponents(calendar: .current, year: 2022, month: 4, day: 2).date ?? Date(),
            comment: NSLocalizedString("tour_review_alexander", comment: "")
        )
    ]
}

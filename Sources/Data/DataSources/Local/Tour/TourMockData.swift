//
//  TourMockData.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// The tour catalog, written out in Swift.
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

extension TourMockData {
    static func detail(id: String) -> TourDetailModel? {
        guard let tour = all.first(where: { $0.id == id }) else { return nil }
        let isTour = tour.type == .tour

        return TourDetailModel(
            id: tour.id,
            type: tour.type,
            title: tour.title,
            description: isTour ? description : nil,
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

    private static let departureTimes = ["7:00", "9:00", "11:00", "13:00", "15:00"]

    private static let tourWaypoints = ["Kronstadt", "Gulf of Finland", "Forts", "Dam"]

    private static let originDisplayNames = [
        "st_petersburg": "St Petersburg",
        "novosibirsk": "Novosibirsk"
    ]

    private static func originCity(for tour: TourModel) -> String {
        originDisplayNames[tour.originSlug] ?? tour.airfield ?? tour.title
    }

    private static func flightWaypoints(for tour: TourModel) -> [String] {
        guard let destination = tour.title.components(separatedBy: " - ").last,
              destination != tour.title else {
            return []
        }
        return [destination]
    }

    private static var description: String {
        NSLocalizedString("tour_detail_description", comment: "")
    }

    private static let durationMinutes = [20, 35, 40, 50, 60]

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

    private static let pilot = PilotModel(
        name: "Oleg Samsonov",
        avatarURL: "https://i.pravatar.cc/150?u=airly-pilot-oleg",
        rating: 5.0,
        airplane: "Cessna 172",
        hoursFlown: 1250,
        license: NSLocalizedString("pilot_license_cpl", comment: "")
    )

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
        ),
        TourReviewModel(
            id: "review_maria",
            authorName: "Maria",
            authorAvatarURL: "https://i.pravatar.cc/150?u=airly-review-maria",
            rating: 5,
            date: DateComponents(calendar: .current, year: 2022, month: 3, day: 14).date ?? Date(),
            comment: NSLocalizedString("tour_review_maria", comment: "")
        ),
        TourReviewModel(
            id: "review_dmitry",
            authorName: "Dmitry",
            authorAvatarURL: "https://i.pravatar.cc/150?u=airly-review-dmitry",
            rating: 4,
            date: DateComponents(calendar: .current, year: 2022, month: 2, day: 8).date ?? Date(),
            comment: NSLocalizedString("tour_review_dmitry", comment: "")
        ),
        TourReviewModel(
            id: "review_elena",
            authorName: "Elena",
            authorAvatarURL: "https://i.pravatar.cc/150?u=airly-review-elena",
            rating: 5,
            date: DateComponents(calendar: .current, year: 2022, month: 1, day: 30).date ?? Date(),
            comment: NSLocalizedString("tour_review_elena", comment: "")
        ),
        TourReviewModel(
            id: "review_sergey",
            authorName: "Sergey",
            authorAvatarURL: "https://i.pravatar.cc/150?u=airly-review-sergey",
            rating: 5,
            date: DateComponents(calendar: .current, year: 2021, month: 12, day: 19).date ?? Date(),
            comment: NSLocalizedString("tour_review_sergey", comment: "")
        )
    ]
}

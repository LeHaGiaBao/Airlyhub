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

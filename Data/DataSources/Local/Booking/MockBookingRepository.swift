//
//  MockBookingRepository.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Bookings held in memory, seeded so My Tickets has something to show before a
/// user has booked anything — the same role `MockFavoritesRepository` plays for
/// Favorites.
///
/// A shared instance rather than one per screen: a booking made on Checkout has to
/// show up when My Tickets is opened next, and a per-screen copy would lose it the
/// moment the app is backgrounded.
final class MockBookingRepository: BookingRepositoryProtocol {
    static let shared = MockBookingRepository()

    /// Three seeded tickets pulled from `TourMockData` by id, the same way
    /// `MockFavoritesRepository.seed` is — a record renamed there breaks this
    /// loudly (the ticket renders empty) instead of silently showing stale copy.
    private static let seed: [BookingModel] = [
        makeSeed(tourID: "tour_kronstadt_cessna172_selzo",
                reference: "673-843", daysAgo: 2, departureTime: "13:30", durationMinutes: 50),
        makeSeed(tourID: "tour_kronstadt_cetus900",
                reference: "902-118", daysAgo: 5, departureTime: "9:00", durationMinutes: 35),
        makeSeed(tourID: "tour_gulf_of_finland_extreme",
                reference: "415-267", daysAgo: 10, departureTime: "15:00", durationMinutes: 70)
    ]

    private var bookings: [BookingModel]
    private let latency: TimeInterval

    init(seed: [BookingModel] = MockBookingRepository.seed, latency: TimeInterval = 0.3) {
        self.bookings = seed
        self.latency = latency
    }

    // MARK: - BookingRepositoryProtocol

    func create(_ draft: BookingDraft,
               cardLast4: String?,
               cardBrand: CardBrand?,
               completion: @escaping (Result<String, Error>) -> Void) {
        let id = UUID().uuidString
        let booking = BookingModel(
            id: id,
            tourId: draft.tourId,
            tourTitle: draft.tourTitle,
            imageURL: draft.imageURL,
            reference: BookingReference.make(),
            airfield: draft.airfield,
            date: draft.date,
            departureTime: draft.departureTime,
            durationMinutes: draft.durationMinutes,
            passengers: draft.passengers,
            amount: draft.amount,
            currencyCode: draft.currencyCode,
            cardLast4: cardLast4,
            cardBrand: cardBrand,
            status: .paid,
            createdAt: Date()
        )

        // Newest first, matching `fetchBookings`' ordering.
        bookings.insert(booking, at: 0)

        DispatchQueue.main.asyncAfter(deadline: .now() + latency) {
            completion(.success(id))
        }
    }

    func fetchBookings(completion: @escaping (Result<[BookingModel], Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + latency) { [bookings] in
            completion(.success(bookings))
        }
    }

    // MARK: - Seed

    private static func makeSeed(tourID: String,
                                 reference: String,
                                 daysAgo: Int,
                                 departureTime: String,
                                 durationMinutes: Int?) -> BookingModel {
        guard let tour = TourMockData.all.first(where: { $0.id == tourID }) else {
            fatalError("Seed tour id \(tourID) is missing from TourMockData.all")
        }

        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()

        return BookingModel(
            id: tourID,
            tourId: tour.id,
            tourTitle: tour.title,
            imageURL: tour.imageURL,
            reference: reference,
            airfield: tour.airfield ?? "",
            date: date,
            departureTime: departureTime,
            durationMinutes: durationMinutes,
            passengers: 1,
            amount: tour.price,
            currencyCode: tour.currencyCode,
            cardLast4: nil,
            cardBrand: nil,
            status: .paid,
            createdAt: date
        )
    }
}

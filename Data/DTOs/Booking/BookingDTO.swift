//
//  BookingDTO.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import FirebaseFirestore

/// Firestore representation of the top-level `bookings/{bookingId}` collection.
///
/// Ownership is the `userId` field, not the path — matching `cards`, not
/// `conversations`. That trade is deliberate: a subcollection under `users/{uid}`
/// keeps the security rules to a path comparison and needs no composite index, but
/// it also means the collection never appears in the console's top-level list —
/// finding a booking means opening the right `users` document first. A top-level
/// collection is the one the console actually shows, at the cost of the composite
/// index `userId ASC, createdAt ASC` `BookingService.fetchBookings` needs — see
/// that type for the query.
struct BookingDTO: Codable {
    let userId: String
    let tourId: String
    let tourTitle: String
    let imageURL: String?
    let reference: String
    let airfield: String
    let date: Date
    let departureTime: String
    let durationMinutes: Int?
    let passengers: Int
    /// `Double`, unlike `BookingModel.amount` and `TourDTO.price`, which are
    /// `Decimal`.
    ///
    /// Foundation encodes `Decimal` through a *keyed* container — `exponent`,
    /// `length`, `isNegative`, `isCompact`, `mantissa`. `JSONEncoder` special-cases
    /// the type and writes a plain number; `Firestore.Encoder` does not, so a
    /// `Decimal` field lands in the document as a nested map instead of a number.
    /// That breaks the `amount is number` check in the security rules and leaves
    /// the stored value unreadable by anything but this client.
    ///
    /// `TourDTO.price` gets away with `Decimal` only because `TourService` never
    /// writes — it decodes numbers typed by hand in the console. This DTO is the
    /// first one written back, so the conversion happens here at the boundary and
    /// the domain keeps its exact type.
    let amount: Double
    let currencyCode: String
    let cardLast4: String?
    let cardBrand: String?
    let status: String

    /// Left nil on write so Firestore stamps the server clock, matching `CardDTO`.
    @ServerTimestamp var createdAt: Timestamp?
}

// MARK: - Mapping
extension BookingDTO {
    func toDomain(id: String) -> BookingModel {
        BookingModel(
            id: id,
            tourId: tourId,
            tourTitle: tourTitle,
            imageURL: imageURL,
            reference: reference,
            airfield: airfield,
            date: date,
            departureTime: departureTime,
            durationMinutes: durationMinutes,
            passengers: passengers,
            amount: Decimal(amount),
            currencyCode: currencyCode,
            cardLast4: cardLast4,
            cardBrand: cardBrand.flatMap(CardBrand.init(rawValue:)),
            status: BookingStatus(rawValue: status) ?? .paid,
            createdAt: createdAt?.dateValue() ?? Date()
        )
    }

    static func make(draft: BookingDraft, userId: String, cardLast4: String?, cardBrand: CardBrand?) -> BookingDTO {
        BookingDTO(
            userId: userId,
            tourId: draft.tourId,
            tourTitle: draft.tourTitle,
            imageURL: draft.imageURL,
            reference: BookingReference.make(),
            airfield: draft.airfield,
            date: draft.date,
            departureTime: draft.departureTime,
            durationMinutes: draft.durationMinutes,
            passengers: draft.passengers,
            amount: NSDecimalNumber(decimal: draft.amount).doubleValue,
            currencyCode: draft.currencyCode,
            cardLast4: cardLast4,
            cardBrand: cardBrand?.rawValue,
            status: BookingStatus.paid.rawValue,
            createdAt: nil
        )
    }
}

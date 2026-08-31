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
    let amount: Double
    let currencyCode: String
    let cardLast4: String?
    let cardBrand: String?
    let status: String

    @ServerTimestamp var createdAt: Timestamp?
}

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

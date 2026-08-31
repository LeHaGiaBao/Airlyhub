//
//  BookingRepositoryProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// The signed-in user's bookings, as the feature layer sees it.
protocol BookingRepositoryProtocol: AnyObject {
    func create(_ draft: BookingDraft,
                cardLast4: String?,
                cardBrand: CardBrand?,
                completion: @escaping (Result<String, Error>) -> Void)

    func fetchBookings(completion: @escaping (Result<[BookingModel], Error>) -> Void)
}

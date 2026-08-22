//
//  TourDetailRouterProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol TourDetailRouterProtocol: AnyObject {
    func dismiss()
    /// Takes the reviews directly rather than a tour id — the detail screen has
    /// already loaded them, and a lookup here would only re-fetch what is already
    /// on screen. Same call as `MyTicketDetailBuilder.build(ticket:)`.
    func showAllReviews(_ reviews: [TourReviewModel])
    func startBooking(_ draft: BookingDraft)
}

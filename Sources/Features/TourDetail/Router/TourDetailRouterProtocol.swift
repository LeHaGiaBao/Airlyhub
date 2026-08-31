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
    func showAllReviews(_ reviews: [TourReviewModel])
    func startBooking(_ draft: BookingDraft)
}

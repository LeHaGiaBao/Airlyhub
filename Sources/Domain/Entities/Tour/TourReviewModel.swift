//
//  TourReviewModel.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// One entry under "Customer reviews" on the detail screen.
struct TourReviewModel {
    let id: String
    let authorName: String
    let authorAvatarURL: String?
    let rating: Int
    let date: Date
    let comment: String
}

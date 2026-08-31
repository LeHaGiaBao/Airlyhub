//
//  ExploreEntity.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// One card of the "Helpful information" carousel on the Explore screen,
/// together with the article shown in its detail bottom sheet.
struct HelpfulInformationItem {
    let id: String
    let title: String
    let imageName: String?
    let summary: String
    let facts: [String]

    init(id: String = UUID().uuidString,
         title: String,
         imageName: String? = nil,
         summary: String = "",
         facts: [String] = []) {
        self.id = id
        self.title = title
        self.imageName = imageName
        self.summary = summary
        self.facts = facts
    }
}

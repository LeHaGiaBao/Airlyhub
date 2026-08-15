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
///
/// `imageName` is the name of an image set in `Assets.xcassets`. While the
/// artwork is not there yet the card falls back to an empty image slot.
struct HelpfulInformationItem {
    let id: String
    let title: String
    let imageName: String?
    /// Lead paragraph of the detail sheet.
    let summary: String
    /// Bullet points listed under the summary.
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

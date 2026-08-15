//
//  ExploreInteractor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import Foundation

final class ExploreInteractor: ExploreInteractorProtocol {
    /// Static content for now — the artwork lives in `Assets.xcassets` under
    /// the image names below, the copy in `Localizable.strings`.
    func fetchHelpfulInformation() -> [HelpfulInformationItem] {
        [
            makeItem(id: "white_airplanes", key: "white_airplanes", imageName: "helpfulInfoWhiteAirplanes"),
            makeItem(id: "facts_flying", key: "facts_flying", imageName: "helpfulInfoFactsFlying"),
            makeItem(id: "water_loss", key: "water_loss", imageName: "helpfulInfoWaterLoss"),
            makeItem(id: "pilot_meals", key: "pilot_meals", imageName: "helpfulInfoPilotMeals")
        ]
    }

    /// Builds an item from the `helpful_info_<key>*` string keys.
    /// Every article has four bullet points.
    private func makeItem(id: String, key: String, imageName: String) -> HelpfulInformationItem {
        HelpfulInformationItem(
            id: id,
            title: NSLocalizedString("helpful_info_\(key)", comment: ""),
            imageName: imageName,
            summary: NSLocalizedString("helpful_info_\(key)_summary", comment: ""),
            facts: (1...4).map { NSLocalizedString("helpful_info_\(key)_fact_\($0)", comment: "") }
        )
    }
}

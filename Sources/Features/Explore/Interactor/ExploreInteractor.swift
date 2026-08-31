//
//  ExploreInteractor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import Foundation

final class ExploreInteractor: ExploreInteractorProtocol {
    func fetchHelpfulInformation() -> [HelpfulInformationItem] {
        [
            makeItem(id: "white_airplanes", key: "white_airplanes", imageName: "helpfulInfoWhiteAirplanes"),
            makeItem(id: "facts_flying", key: "facts_flying", imageName: "helpfulInfoFactsFlying"),
            makeItem(id: "water_loss", key: "water_loss", imageName: "helpfulInfoWaterLoss"),
            makeItem(id: "pilot_meals", key: "pilot_meals", imageName: "helpfulInfoPilotMeals")
        ]
    }

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

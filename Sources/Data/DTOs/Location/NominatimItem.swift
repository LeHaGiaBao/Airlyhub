//
//  NominatimItem.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 30/05/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

struct NominatimItem: Decodable {
    let address: NominatimAddress?

    func toLocationResult() -> LocationResult? {
        guard let address else { return nil }
        let city = address.city
            ?? address.town
            ?? address.village
            ?? address.county
            ?? address.state
            ?? ""
        let country = address.country ?? ""
        guard !city.isEmpty, !country.isEmpty else { return nil }
        return LocationResult(city: city, country: country)
    }
}

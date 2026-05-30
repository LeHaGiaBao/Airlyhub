//
//  NominatimAddress.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 30/05/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

struct NominatimAddress: Decodable {
    let city: String?
    let town: String?
    let village: String?
    let county: String?
    let state: String?
    let country: String?
}

//
//  TourSlug.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Turns a place name into the key the catalog is indexed by.
enum TourSlug {
    private static let aliases: [String: String] = [
        "saint_petersburg": "st_petersburg",
        "sankt_peterburg": "st_petersburg",
        "sankt_petersburg": "st_petersburg",
        "petersburg": "st_petersburg",
        "leningrad": "st_petersburg",
        "kronstadt": "st_petersburg",
        "peterhof": "st_petersburg",
        "санкт_петербург": "st_petersburg",
        "новосибирск": "novosibirsk",
        "lake_baikal": "baikal",
        "баикал": "baikal",
        "irkutsk": "baikal",
        "altay": "altai",
        "gorno_altaysk": "altai",
        "алтаи": "altai",
        "красноярск": "krasnoyarsk"
    ]

    static func make(from name: String) -> String {
        let normalized = normalize(name)
        return aliases[normalized] ?? normalized
    }

    static func make(from location: LocationResult) -> String {
        make(from: location.city)
    }

    private static func normalize(_ name: String) -> String {
        let folded = name.folding(
            options: [.diacriticInsensitive, .caseInsensitive],
            locale: Locale(identifier: "en_US_POSIX")
        )

        return folded
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .joined(separator: "_")
            .lowercased()
    }
}

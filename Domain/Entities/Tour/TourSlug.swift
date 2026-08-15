//
//  TourSlug.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Turns a place name into the key the catalog is indexed by.
///
/// The catalog has no full-text search — a place is matched by equality on a
/// normalized slug ("St. Petersburg" → `st_petersburg`), and both sides of the
/// comparison run through here, which is what makes the lookup deterministic.
///
/// Normalizing alone is not enough, because the two sides do not agree on
/// spelling. The catalog picks one key per place, while `LocationFinder` returns
/// whatever Nominatim calls it in the device's language — "Saint Petersburg",
/// "Sankt-Peterburg", "Санкт-Петербург". Folding strips diacritics but does not
/// transliterate, so a Cyrillic name survives unchanged and matches nothing. That
/// is what `aliases` below repairs.
enum TourSlug {
    /// Alternate spellings mapped onto the catalog's key for the same place.
    ///
    /// Hardcoded because the catalog is a fixed mock of five places; a real one
    /// would carry its own `nameVariants` per record so the table grows with the
    /// data instead of with the app. Kronstadt and Peterhof map to St Petersburg
    /// on purpose — the tours depart from those airfields, and a user who searches
    /// for either means the same trip.
    ///
    /// Keys must be written in **normalized** form, since that is what they are
    /// looked up against. That is not always the obvious spelling: folding treats
    /// Cyrillic "й" as a diacritic and strips it to "и", so Байкал normalizes to
    /// `баикал` and an entry spelled `байкал` would never be found.
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

    /// Convenience for the value `LocationFinder` hands back.
    static func make(from location: LocationResult) -> String {
        make(from: location.city)
    }

    /// Lowercased, diacritics stripped, every run of non-alphanumerics collapsed to
    /// a single underscore.
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

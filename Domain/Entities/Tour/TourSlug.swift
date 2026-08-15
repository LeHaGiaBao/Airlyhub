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
/// Firestore has no full-text search — a query can test a field for equality but
/// not for "contains". So a place is stored and searched as a normalized slug
/// ("St. Petersburg" → `st_petersburg`) and both sides of the comparison are run
/// through here, which is what makes the lookup deterministic.
///
/// Folding strips diacritics but does not transliterate: a Cyrillic or CJK name
/// comes back unchanged, so the catalog and `LocationFinder` must agree on a
/// language. `RemoteLocationService` asks Nominatim for the device language, so a
/// non-Latin locale will not match a Latin-slugged catalog. Seeding a
/// `nameVariants` array per record is the way out if that becomes a real case.
enum TourSlug {
    static func make(from name: String) -> String {
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

    /// Convenience for the value `LocationFinder` hands back.
    static func make(from location: LocationResult) -> String {
        make(from: location.city)
    }
}

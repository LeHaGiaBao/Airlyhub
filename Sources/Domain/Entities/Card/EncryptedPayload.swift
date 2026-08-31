//
//  EncryptedPayload.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Envelope holding an AES-256-GCM ciphertext.
struct EncryptedPayload: Codable, Equatable {
    let alg: String
    let keyId: String
    let ciphertext: String
    let wrappedKey: String?

    init(alg: String = "AES-256-GCM", keyId: String, ciphertext: String, wrappedKey: String? = nil) {
        self.alg = alg
        self.keyId = keyId
        self.ciphertext = ciphertext
        self.wrappedKey = wrappedKey
    }
}

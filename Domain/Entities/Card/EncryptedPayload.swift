//
//  EncryptedPayload.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Envelope holding an AES-256-GCM ciphertext.
///
/// `ciphertext` is base64 of CryptoKit's *combined* representation:
/// `nonce (12 bytes) || ciphertext || tag (16 bytes)`. A backend that needs to
/// read it must split on those fixed offsets.
///
/// `wrappedKey` is only populated by the hybrid RSA variant, where the per-card
/// data key travels alongside the payload encrypted with the server's public key.
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

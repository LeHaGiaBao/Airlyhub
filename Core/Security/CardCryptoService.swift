//
//  CardCryptoService.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import CryptoKit

enum CardCryptoError: LocalizedError {
    case keyUnavailable
    case encryptionFailed
    case decryptionFailed

    var errorDescription: String? {
        NSLocalizedString("error_card_encryption_failed", comment: "")
    }
}

/// Encrypts card numbers with AES-256-GCM under a key that never leaves the device.
///
/// The key is generated on first use and kept in the keychain, so what lands in
/// Firestore is ciphertext that neither Firebase nor a project admin can open.
/// The cost of that guarantee: reinstalling the app or switching devices drops the
/// key, and existing ciphertext becomes undecryptable — callers should treat a
/// `decryptionFailed` as "ask the user to re-add this card".
final class CardCryptoService {
    static let shared = CardCryptoService()

    /// Stamped into every payload so a future key rotation can tell generations apart.
    static let currentKeyId = "dk-local-v1"

    private let keychain: KeychainStoring
    private let deviceKeyAccount = "card-device-key"

    init(keychain: KeychainStoring = KeychainService(service: "airly.Airlyhub.cards")) {
        self.keychain = keychain
    }

    /// Loads the device key, generating and persisting one on first call.
    private func deviceKey() throws -> SymmetricKey {
        if let existing = keychain.data(for: deviceKeyAccount), existing.count == 32 {
            return SymmetricKey(data: existing)
        }

        let key = SymmetricKey(size: .bits256)
        let raw = key.withUnsafeBytes { Data($0) }
        guard keychain.set(raw, for: deviceKeyAccount) else {
            throw CardCryptoError.keyUnavailable
        }
        return key
    }

    /// Produces a payload whose `ciphertext` is base64 of `nonce || ciphertext || tag`.
    func encrypt(_ plaintext: String) throws -> EncryptedPayload {
        let key = try deviceKey()

        guard let sealed = try? AES.GCM.seal(Data(plaintext.utf8), using: key),
              let combined = sealed.combined else {
            throw CardCryptoError.encryptionFailed
        }

        return EncryptedPayload(
            keyId: Self.currentKeyId,
            ciphertext: combined.base64EncodedString()
        )
    }

    func decrypt(_ payload: EncryptedPayload) throws -> String {
        let key = try deviceKey()

        guard let combined = Data(base64Encoded: payload.ciphertext),
              let sealed = try? AES.GCM.SealedBox(combined: combined),
              let opened = try? AES.GCM.open(sealed, using: key),
              let plaintext = String(data: opened, encoding: .utf8) else {
            throw CardCryptoError.decryptionFailed
        }
        return plaintext
    }

    /// Drops the device key. Every stored ciphertext becomes unreadable, so this is
    /// only appropriate on sign-out-and-wipe or account deletion.
    func resetKey() {
        keychain.delete(account: deviceKeyAccount)
    }
}

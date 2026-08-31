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

final class CardCryptoService {
    static let shared = CardCryptoService()

    static let currentKeyId = "dk-local-v1"

    private let keychain: KeychainStoring
    private let deviceKeyAccount = "card-device-key"

    init(keychain: KeychainStoring = KeychainService(service: "airly.Airlyhub.cards")) {
        self.keychain = keychain
    }

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

    func resetKey() {
        keychain.delete(account: deviceKeyAccount)
    }
}

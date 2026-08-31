//
//  ChatAttachmentRepositoryProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 31/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Storage for support-chat attachment bytes (Realtime Database on the free plan,
/// which provisions no Cloud Storage bucket).
///
/// The message document only carries a `path`; the payload lives here.
protocol ChatAttachmentRepositoryProtocol: AnyObject {
    /// Whether attachment storage is configured for this build. `false` disables
    /// picking a file but leaves text chat working.
    var isAvailable: Bool { get }

    /// Stores `data` and returns the `path` to record on the message.
    func upload(uid: String,
                attachmentId: String,
                data: Data,
                completion: @escaping (Result<String, Error>) -> Void)

    /// Fetches and decodes an attachment, serving from an in-memory cache when
    /// possible. Calls back on the main queue.
    func load(path: String, completion: @escaping (Data?) -> Void)
}

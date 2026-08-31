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
protocol ChatAttachmentRepositoryProtocol: AnyObject {
    var isAvailable: Bool { get }

    func upload(uid: String,
                attachmentId: String,
                data: Data,
                completion: @escaping (Result<String, Error>) -> Void)

    func load(path: String, completion: @escaping (Data?) -> Void)
}

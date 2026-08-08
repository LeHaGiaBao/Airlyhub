//
//  DatabaseNode.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 09/08/2026.
//

import Foundation

struct DatabaseNode {
    /// Base64-encoded JPEG per user, keyed by uid — see `AvatarService`.
    static let avatars = "avatars"
    static let chatAttachments = "chatAttachments"
}

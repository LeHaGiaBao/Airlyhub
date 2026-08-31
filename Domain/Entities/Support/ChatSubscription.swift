//
//  ChatSubscription.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 31/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// A handle to a live message stream. Calling `remove()` tears the listener down —
/// the caller **must**, or the underlying query keeps billing reads and retaining
/// its callback for the app's lifetime.
///
/// This is the domain stand-in for Firestore's `ListenerRegistration`, so the
/// interactor can cancel a stream without importing the SDK.
struct ChatSubscription {
    private let onRemove: () -> Void

    init(onRemove: @escaping () -> Void) {
        self.onRemove = onRemove
    }

    func remove() {
        onRemove()
    }
}

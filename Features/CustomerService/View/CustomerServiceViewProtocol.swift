//
//  CustomerServiceViewProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol CustomerServiceViewProtocol: AnyObject {
    func render(_ state: CustomerServiceViewState)
    /// Called the moment a send is accepted, before it reaches the server — the bubble
    /// arrives from the listener, so the field must not wait for a round trip to empty.
    func clearInput()
    /// Blocks a second send while an attachment is uploading. Plain text sends are
    /// instant and never toggle this.
    func setSending(_ isSending: Bool)
    func showToast(_ message: String, style: ToastStyle)
}

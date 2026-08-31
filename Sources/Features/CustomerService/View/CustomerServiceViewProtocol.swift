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
    func clearInput()
    func setSending(_ isSending: Bool)
    func showToast(_ message: String, style: ToastStyle)
}

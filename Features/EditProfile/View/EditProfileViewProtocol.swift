//
//  EditProfileViewProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 25/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol EditProfileViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func prefill(email: String, name: String, phone: String, avatarURL: String?)
    func showToast(_ message: String, style: ToastStyle)
}

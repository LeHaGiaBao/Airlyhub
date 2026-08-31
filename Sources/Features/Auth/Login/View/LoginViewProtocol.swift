//
//  LoginViewProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol LoginViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
}

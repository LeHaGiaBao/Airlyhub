//
//  LoginPresenterProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol LoginPresenterProtocol {
    func viewDidLoad()
    func loginTapped(email: String, password: String)
    func isValidEmail(_ email: String) -> (Bool, String?)
    func isValidPassword(_ password: String) -> (Bool, String?)
    func goToRegister()
}

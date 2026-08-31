//
//  EditProfilePresenterProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 25/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol EditProfilePresenterProtocol: AnyObject {
    func viewDidLoad()
    func isValidName(_ name: String) -> (Bool, String?)
    func isValidPhone(_ phone: String) -> (Bool, String?)
    func isValidOldPassword(_ oldPassword: String, isChangingPassword: Bool) -> (Bool, String?)
    func isValidNewPassword(_ password: String) -> (Bool, String?)
    func isValidConfirmPassword(_ confirmPassword: String, matching newPassword: String) -> (Bool, String?)
    func isSaveEnabled(_ form: EditProfileFormState) -> Bool
    func saveTapped(name: String, phone: String, oldPassword: String, newPassword: String, confirmPassword: String)
    func updateAvatar(imageData: Data)
    func dismiss()
}

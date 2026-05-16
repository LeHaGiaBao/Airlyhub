//
//  LoginProtocols.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/12/2025.
//

import UIKit
import RxSwift

protocol LoginViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func showEmailError(_ message: String)
    func showPasswordError(_ message: String)
}

protocol LoginPresenterProtocol {
    func viewDidLoad()
    func loginTapped(email: String, password: String)
    func isValidEmail(_ email: String) -> (Bool, String?)
    func isValidPassword(_ password: String) -> (Bool, String?)
    func validateEmail(email: String)
    func validatePassword(password: String)
    func goToRegister()
}

protocol LoginInteractorProtocol {
    func login(email: String, password: String) -> Observable<Void>
}

protocol LoginRouterProtocol {
    func navigateToHome()
    func navigateToRegister()
}

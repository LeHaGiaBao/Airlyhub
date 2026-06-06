//
//  RegisterProtocols.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 21/03/2026.
//

import UIKit
import RxSwift

protocol RegisterViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
}

protocol RegisterPresenterProtocol {
    func viewDidLoad()
    func registerTapped(name: String, email: String, password: String, confirmPassword: String)
    func isValidFullname(_ name: String) -> (Bool, String?)
    func isValidEmail(_ email: String) -> (Bool, String?)
    func isValidPassword(_ password: String) -> (Bool, String?)
    func goToLogin()
}

protocol RegisterInteractorProtocol {
    func register(name: String, email: String, password: String) -> Observable<Void>
}

protocol RegisterRouterProtocol {
    func navigateToHome()
    func navigateToLogin()
}

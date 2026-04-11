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
}

protocol RegisterInteractorProtocol {
    func register(name: String, email: String, password: String) -> Observable<Void>
}

protocol RegisterRouterProtocol {
    func navigateToHome()
}

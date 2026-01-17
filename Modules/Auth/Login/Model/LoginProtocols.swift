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
}

protocol LoginPresenterProtocol {
    func viewDidLoad()
    func loginTapped(username: String, password: String)
}

protocol LoginInteractorProtocol {
    func login(username: String, password: String) -> Observable<Bool>
}

protocol LoginRouterProtocol {
    func navigateToHome()
}

//
//  LoginPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/12/2025.
//

import Foundation
import RxSwift

final class LoginPresenter: LoginPresenterProtocol {
    weak var view: LoginViewProtocol?
    let interactor: LoginInteractorProtocol
    let router: LoginRouterProtocol
    let disposeBag = DisposeBag()

    init(
        view: LoginViewProtocol,
        interactor: LoginInteractorProtocol,
        router: LoginRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {}

    func loginTapped(email: String, password: String) {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !password.isEmpty else {
            view?.showError("Please enter email and password.")
            return
        }

        view?.showLoading()

        interactor.login(email: trimmed, password: password)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] in
                    self?.view?.hideLoading()
                    self?.router.navigateToHome()
                },
                onError: { [weak self] error in
                    self?.view?.hideLoading()
                    self?.view?.showError(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func isValidEmail(_ email: String) -> (Bool, String?) {
        let result = Validation.validEmail(email)
        if !result.isValid {
            return (false, result.errorMessage)
        }
        return (true, nil)
    }
    
    func isValidPassword(_ password: String) -> (Bool, String?) {
        let result = Validation.validPassword(password)
        if !result.isValid {
            return (false, result.errorMessage)
        }
        return (true, nil)
    }
    
    func validateEmail(email: String) {
        let (result, errorMessage) = isValidEmail(email)
        if !result {
            view?.showEmailError(errorMessage ?? "")
        }
    }
    
    func validatePassword(password: String) {
        let (result, errorMessage) = isValidPassword(password)
        if !result {
            view?.showEmailError(errorMessage ?? "")
        }
    }
    
    func goToRegister() {
        router.navigateToRegister()
    }
}

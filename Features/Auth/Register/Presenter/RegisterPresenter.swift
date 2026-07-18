//
//  RegisterPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 21/03/2026.
//

import Foundation
import RxSwift

final class RegisterPresenter: RegisterPresenterProtocol {
    weak var view: RegisterViewProtocol?
    let interactor: RegisterInteractorProtocol
    let router: RegisterRouterProtocol
    let disposeBag = DisposeBag()

    init(view: RegisterViewProtocol,
         interactor: RegisterInteractorProtocol,
         router: RegisterRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {}

    func registerTapped(name: String, email: String, password: String, confirmPassword: String) {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty, !password.isEmpty else {
            view?.showError(NSLocalizedString("validation_email_and_password", comment: ""))
            return
        }
        guard password == confirmPassword else {
            view?.showError(NSLocalizedString("validation_invalid_password_not_matching", comment: ""))
            return
        }

        view?.showLoading()

        interactor.register(name: name, email: trimmedEmail, password: password)
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
    
    func isValidFullname(_ name: String) -> (Bool, String?) {
        let result = Validation.validFullName(name)
        if !result.isValid {
            return (false, result.errorMessage)
        }
        return (true, nil)
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
    
    func goToLogin() {
        router.navigateToLogin()
    }
}

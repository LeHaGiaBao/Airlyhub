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
}

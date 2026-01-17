//
//  LoginPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/12/2025.
//

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

    func loginTapped(username: String, password: String) {
        view?.showLoading()

        interactor.login(username: username, password: password)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] success in
                self?.view?.hideLoading()
                success ? self?.router.navigateToHome()
                        : self?.view?.showError("Login failed")
            })
            .disposed(by: disposeBag)
    }
}

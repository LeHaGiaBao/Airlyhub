//
//  LoginViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/12/2025.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: BaseViewController {
    var presenter: LoginPresenterProtocol!

    private let loginButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()

        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presenter.loginTapped(
                    username: "test",
                    password: "123456"
                )
            })
            .disposed(by: disposeBag)
    }

    private func setupUI() {
        view.backgroundColor = .white
    }
}

extension LoginViewController: LoginViewProtocol {
    func showLoading() {}
    func hideLoading() {}
    func showError(_ message: String) {}
}

//
//  RegisterViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 21/03/2026.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class RegisterViewController: BaseViewController {
    var presenter: RegisterPresenterProtocol!

    private let nameTextField = UITextField()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let confirmPasswordTextField = UITextField()
    private let submitButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()

        submitButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.view.endEditing(true)
                self.presenter.registerTapped(
                    name: self.nameTextField.text ?? "",
                    email: self.emailTextField.text ?? "",
                    password: self.passwordTextField.text ?? "",
                    confirmPassword: self.confirmPasswordTextField.text ?? ""
                )
            })
            .disposed(by: disposeBag)
    }

    private func setupUI() {
        title = "Register"

        nameTextField.placeholder = "Name"
        nameTextField.autocapitalizationType = .words
        nameTextField.borderStyle = .roundedRect
        nameTextField.textContentType = .name

        emailTextField.placeholder = "Email"
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.textContentType = .emailAddress
        emailTextField.borderStyle = .roundedRect

        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .newPassword
        passwordTextField.borderStyle = .roundedRect

        confirmPasswordTextField.placeholder = "Confirm password"
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.textContentType = .newPassword
        confirmPasswordTextField.borderStyle = .roundedRect

        submitButton.setTitle("Submit", for: .normal)
        submitButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)

        activityIndicator.hidesWhenStopped = true

        let stack = UIStackView(arrangedSubviews: [
            nameTextField,
            emailTextField,
            passwordTextField,
            confirmPasswordTextField,
            submitButton,
            activityIndicator
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill

        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.centerY.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension RegisterViewController: RegisterViewProtocol {
    func showLoading() {
        nameTextField.isEnabled = false
        emailTextField.isEnabled = false
        passwordTextField.isEnabled = false
        confirmPasswordTextField.isEnabled = false
        submitButton.isEnabled = false
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        nameTextField.isEnabled = true
        emailTextField.isEnabled = true
        passwordTextField.isEnabled = true
        confirmPasswordTextField.isEnabled = true
        submitButton.isEnabled = true
        activityIndicator.stopAnimating()
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

//
//  LoginViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/12/2025.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class LoginViewController: BaseViewController {
    var presenter: LoginPresenterProtocol!

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("welcome_back_to", comment: "")
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppColor.PrimaryColors.Primary.color500
        label.applyTypography(.displaySm(weight: .bold))
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("airlyhub", comment: "")
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppColor.PrimaryColors.Gray.color700
        label.applyTypography(.displaySm(weight: .bold))
        return label
    }()
    
    private let emailTextField: TextField = {
        let field = TextField()
        field.label = NSLocalizedString("email", comment: "")
        field.placeholder = NSLocalizedString("email_placeholder", comment: "")
        field.setLeadingIcon(UIImage(systemName: "envelope.fill"))
        field.textField.keyboardType = .emailAddress
        field.textField.autocapitalizationType = .none
        field.textField.autocorrectionType = .no
        field.textField.textContentType = .emailAddress
        field.textField.returnKeyType = .next
        return field
    }()
    
    private let passwordTextField: TextField = {
        let field = TextField()
        field.label = NSLocalizedString("passsword", comment: "")
        field.placeholder = NSLocalizedString("passsword_placeholder", comment: "")
        field.setLeadingIcon(UIImage(systemName: "lock.fill"))
        field.setTrailingIcon(UIImage(systemName: "eye.slash.fill"))
        field.textField.keyboardType = .default
        field.textField.autocapitalizationType = .none
        field.textField.autocorrectionType = .no
        field.textField.textContentType = .password
        field.textField.isSecureTextEntry = true
        field.textField.returnKeyType = .go
        return field
    }()
    
    private var isPasswordVisible: Bool = false
    private var submitButtonBottomConstraint: Constraint?
    private var submitButtonKeyboardConstraint: Constraint?
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("login", comment: ""), for: .normal)
        button.applyButtonStyle(.defaultButton(size: .big))
        return button
    }()
    
    private let registerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 4
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let registerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("do_not_have_account", comment: "")
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppColor.PrimaryColors.Gray.color700
        label.applyTypography(.textMd(weight: .medium))
        return label
    }()
    
    private let registerButton: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("register", comment: "")
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppColor.PrimaryColors.Primary.color500
        label.applyTypography(.textMd(weight: .bold))
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = .white
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvents()
        setupKeyboardHandling()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)

        view.addSubview(registerStack)
        registerStack.addArrangedSubview(registerTitleLabel)
        registerStack.addArrangedSubview(registerButton)

        view.addSubview(submitButton)
        submitButton.addSubview(activityIndicator)

        registerStack.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-Devices.bottomSafeHeight - 16)
            make.centerX.equalToSuperview()
        }

        submitButton.snp.makeConstraints { make in
            submitButtonBottomConstraint = make.bottom.equalTo(registerStack.snp.top).offset(-16).constraint
            make.left.right.equalToSuperview().inset(Devices.paddingHorizontal)
        }
        submitButton.snp.prepareConstraints { make in
            submitButtonKeyboardConstraint = make.bottom.equalTo(view.snp.bottom).constraint
        }

        activityIndicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(submitButton.titleLabel!.snp.leading).offset(-8)
        }

        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(submitButton.snp.top).offset(-24)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            make.height.greaterThanOrEqualTo(scrollView.snp.height)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Devices.topBarSafeHeight + 44)
            make.left.right.equalToSuperview().inset(Devices.paddingHorizontal)
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(Devices.paddingHorizontal)
        }

        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(Devices.paddingHorizontal)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(Devices.paddingHorizontal)
            make.bottom.lessThanOrEqualToSuperview().offset(-24)
        }

        emailTextField.applyState(.defaultInput)
        passwordTextField.applyState(.defaultInput)
    }
    
    private func setupEvents() {
        let emailValid = emailTextField.textField.rx.text.orEmpty
            .map { [weak self] email in
                self?.presenter.isValidEmail(email).0 ?? false
            }
        
        let passwordValid = passwordTextField.textField.rx.text.orEmpty
            .map { [weak self] password in
                self?.presenter.isValidPassword(password).0 ?? false
            }
        
        let isFormValid = Observable.combineLatest(
            emailValid,
            passwordValid
        ) { $0 && $1 }
        
        isFormValid
            .bind(to: submitButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        emailTextField.textField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(emailTextField.textField.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] email in
                guard let self = self else { return }
                let validation = self.presenter.isValidEmail(email)
                if !validation.0, !email.isEmpty {
                    self.emailTextField.applyState(.error(message: validation.1))
                } else {
                    self.emailTextField.applyState(.defaultInput)
                }
            })
            .disposed(by: disposeBag)
        
        passwordTextField.textField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(passwordTextField.textField.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] password in
                guard let self = self else { return }
                let validation = self.presenter.isValidPassword(password)
                if !validation.0, !password.isEmpty {
                    self.passwordTextField.applyState(.error(message: validation.1))
                } else {
                    self.passwordTextField.applyState(.defaultInput)
                }
            })
            .disposed(by: disposeBag)
        
        passwordTextField.onTrailingIconTapped = { [weak self] in
            guard let self = self else { return }
            self.isPasswordVisible.toggle()
            self.passwordTextField.textField.isSecureTextEntry = !self.isPasswordVisible
            let iconName = self.isPasswordVisible ? "eye.fill" : "eye.slash.fill"
            self.passwordTextField.setTrailingIcon(UIImage(systemName: iconName))
        }
        
        emailTextField.textField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
                self?.passwordTextField.textField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)

        passwordTextField.textField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
                self?.submitLogin()
            })
            .disposed(by: disposeBag)

        submitButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.submitLogin()
            })
            .disposed(by: disposeBag)
        
        let registerTap = UITapGestureRecognizer()
        registerButton.addGestureRecognizer(registerTap)
        registerTap.rx.event
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                FeedbackGenerator.onFeedbackGenerator(.soft)
                self.presenter.goToRegister()
            })
            .disposed(by: disposeBag)
    }

    private func submitLogin() {
        guard submitButton.isEnabled else { return }
        view.endEditing(true)
        presenter.loginTapped(
            email: emailTextField.textField.text ?? "",
            password: passwordTextField.textField.text ?? ""
        )
    }
}

// MARK: Keyboard Events

extension LoginViewController {
    private func setupKeyboardHandling() {
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { [weak self] notification in
                self?.handleKeyboard(notification: notification, isShowing: true)
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [weak self] notification in
                self?.handleKeyboard(notification: notification, isShowing: false)
            })
            .disposed(by: disposeBag)
    }

    private func handleKeyboard(notification: Notification, isShowing: Bool) {
        guard
            let userInfo = notification.userInfo,
            let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int
        else { return }

        if isShowing {
            let keyboardFrame = view.convert(frameValue.cgRectValue, from: nil)
            let keyboardHeight = view.bounds.height - keyboardFrame.minY
            submitButtonBottomConstraint?.deactivate()
            submitButtonKeyboardConstraint?.update(offset: -(keyboardHeight + 24))
            submitButtonKeyboardConstraint?.activate()
        } else {
            submitButtonKeyboardConstraint?.deactivate()
            submitButtonBottomConstraint?.activate()
        }

        let options = UIView.AnimationOptions(rawValue: UInt(curveRaw << 16))
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.view.layoutIfNeeded()
        }
    }
}

extension LoginViewController: LoginViewProtocol {
    func showLoading() {
        emailTextField.textField.isEnabled = false
        passwordTextField.textField.isEnabled = false
        submitButton.isEnabled = false
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        emailTextField.textField.isEnabled = true
        passwordTextField.textField.isEnabled = true
        submitButton.isEnabled = true
        activityIndicator.stopAnimating()
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

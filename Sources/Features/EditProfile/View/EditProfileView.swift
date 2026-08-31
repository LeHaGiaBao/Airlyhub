//
//  EditProfileView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 25/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import PhotosUI

final class EditProfileView: BaseViewController {
    private let presenter: EditProfilePresenterProtocol
    private let topNavigatorVC: TopNavigatorView

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.tintColor = AppColor.PrimaryColors.Primary.color300
        imageView.backgroundColor = AppColor.PrimaryColors.Primary.color50
        return imageView
    }()

    private let editAvatarButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 14
        button.tintColor = AppColor.PrimaryColors.Gray.color800
        button.setImage(AssetsIcon.pencil, for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.15
        button.layer.shadowRadius = 3
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        return button
    }()

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

    private let emailTextField: TextField = {
        let field = TextField()
        field.label = NSLocalizedString("email", comment: "")
        field.setLeadingIcon(UIImage(systemName: "envelope.fill"))
        field.textField.isEnabled = false
        return field
    }()

    private let nameTextField: TextField = {
        let field = TextField()
        field.label = NSLocalizedString("name", comment: "")
        field.placeholder = NSLocalizedString("name_placeholder", comment: "")
        field.setLeadingIcon(UIImage(systemName: "person.fill"))
        field.textField.autocapitalizationType = .words
        field.textField.autocorrectionType = .no
        field.textField.textContentType = .name
        field.textField.returnKeyType = .next
        return field
    }()

    private let phoneTextField: TextField = {
        let field = TextField()
        field.label = NSLocalizedString("phone", comment: "")
        field.placeholder = NSLocalizedString("phone_placeholder", comment: "")
        field.setLeadingIcon(UIImage(systemName: "phone.fill"))
        field.textField.keyboardType = .phonePad
        field.textField.textContentType = .telephoneNumber
        field.textField.returnKeyType = .next
        return field
    }()

    private let oldPasswordTextField: TextField = {
        let field = TextField()
        field.label = NSLocalizedString("old_password", comment: "")
        field.placeholder = NSLocalizedString("old_password_placeholder", comment: "")
        field.setLeadingIcon(UIImage(systemName: "lock.fill"))
        field.setTrailingIcon(UIImage(systemName: "eye.slash.fill"))
        field.textField.autocapitalizationType = .none
        field.textField.autocorrectionType = .no
        field.textField.textContentType = .password
        field.textField.isSecureTextEntry = true
        field.textField.returnKeyType = .next
        return field
    }()

    private let newPasswordTextField: TextField = {
        let field = TextField()
        field.label = NSLocalizedString("new_password", comment: "")
        field.placeholder = NSLocalizedString("new_password_placeholder", comment: "")
        field.setLeadingIcon(UIImage(systemName: "lock.fill"))
        field.setTrailingIcon(UIImage(systemName: "eye.slash.fill"))
        field.textField.autocapitalizationType = .none
        field.textField.autocorrectionType = .no
        field.textField.textContentType = .newPassword
        field.textField.isSecureTextEntry = true
        field.textField.returnKeyType = .next
        return field
    }()

    private let confirmNewPasswordTextField: TextField = {
        let field = TextField()
        field.label = NSLocalizedString("confirm_new_password", comment: "")
        field.placeholder = NSLocalizedString("confirm_new_password_placeholder", comment: "")
        field.setLeadingIcon(UIImage(systemName: "lock.fill"))
        field.setTrailingIcon(UIImage(systemName: "eye.slash.fill"))
        field.textField.autocapitalizationType = .none
        field.textField.autocorrectionType = .no
        field.textField.textContentType = .newPassword
        field.textField.isSecureTextEntry = true
        field.textField.returnKeyType = .go
        return field
    }()

    private var isPasswordVisible: Bool = false
    private var saveButtonBottomConstraint: Constraint?
    private var saveButtonKeyboardConstraint: Constraint?

    private var originalName: String = ""
    private var originalPhone: String = ""
    private var hasAvatarChanged: Bool = false

    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("save_changes", comment: ""), for: .normal)
        button.applyButtonStyle(.defaultButton(size: .big))
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = .white
        return indicator
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(presenter: EditProfilePresenterProtocol) {
        self.presenter = presenter
        self.topNavigatorVC = TopNavigatorView(topNavigatorTile: NSLocalizedString("edit_profile", comment: ""))
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAvatarEvents()
        setupEvents()
        setupKeyboardHandling()
        presenter.viewDidLoad()
    }
}

private extension EditProfileView {
    func setupUI() {
        view.backgroundColor = .white
        embedTopNavigator()

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(editAvatarButton)
        contentView.addSubview(emailTextField)
        contentView.addSubview(nameTextField)
        contentView.addSubview(phoneTextField)
        contentView.addSubview(oldPasswordTextField)
        contentView.addSubview(newPasswordTextField)
        contentView.addSubview(confirmNewPasswordTextField)

        view.addSubview(saveButton)
        saveButton.addSubview(activityIndicator)

        saveButton.snp.makeConstraints { make in
            saveButtonBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16).constraint
            make.left.right.equalToSuperview().inset(Devices.paddingHorizontal)
        }
        saveButton.snp.prepareConstraints { make in
            saveButtonKeyboardConstraint = make.bottom.equalTo(view.snp.bottom).constraint
        }

        activityIndicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(saveButton.titleLabel?.snp.leading ?? saveButton.snp.leading).offset(-8)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(topNavigatorVC.view.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(saveButton.snp.top).offset(-24)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }

        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }

        editAvatarButton.snp.makeConstraints { make in
            make.trailing.equalTo(avatarImageView.snp.trailing).offset(2)
            make.bottom.equalTo(avatarImageView.snp.bottom).offset(2)
            make.width.height.equalTo(28)
        }

        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(Devices.paddingHorizontal)
        }

        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(Devices.paddingHorizontal)
        }

        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(Devices.paddingHorizontal)
        }

        oldPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(Devices.paddingHorizontal)
        }

        newPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(oldPasswordTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(Devices.paddingHorizontal)
        }

        confirmNewPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(newPasswordTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(Devices.paddingHorizontal)
            make.bottom.lessThanOrEqualToSuperview().offset(-24)
        }

        emailTextField.applyState(.disabled)
        nameTextField.applyState(.defaultInput)
        phoneTextField.applyState(.defaultInput)
        oldPasswordTextField.applyState(.defaultInput)
        newPasswordTextField.applyState(.defaultInput)
        confirmNewPasswordTextField.applyState(.defaultInput)

        saveButton.isEnabled = false
    }

    func setupAvatarEvents() {
        editAvatarButton.addTarget(self, action: #selector(didTapEditAvatar), for: .touchUpInside)
    }

    func embedTopNavigator() {
        addChild(topNavigatorVC)
        view.addSubview(topNavigatorVC.view)
        topNavigatorVC.view.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(56)
        }
        topNavigatorVC.didMove(toParent: self)
        topNavigatorVC.onCloseAction = { [weak self] in
            self?.presenter.dismiss()
        }
    }
}

private extension EditProfileView {
    func setupEvents() {
        bindSaveButtonRefresh()
        bindFieldValidation()
        bindPasswordVisibilityToggle()
        bindReturnKeyChaining()

        saveButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.submitChanges()
            })
            .disposed(by: disposeBag)
    }

    func bindSaveButtonRefresh() {
        [nameTextField, phoneTextField, oldPasswordTextField, newPasswordTextField, confirmNewPasswordTextField].forEach { field in
            field.textField.rx.controlEvent(.editingChanged)
                .subscribe(onNext: { [weak self] in
                    self?.updateSaveButtonState()
                })
                .disposed(by: disposeBag)
        }
    }

    func bindFieldValidation() {
        nameTextField.textField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(nameTextField.textField.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] name in
                guard let self else { return }
                let validation = self.presenter.isValidName(name)
                self.nameTextField.applyState(!validation.0 && !name.isEmpty ? .error(message: validation.1) : .defaultInput)
            })
            .disposed(by: disposeBag)

        phoneTextField.textField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(phoneTextField.textField.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] phone in
                guard let self else { return }
                let validation = self.presenter.isValidPhone(phone)
                self.phoneTextField.applyState(!validation.0 && !phone.isEmpty ? .error(message: validation.1) : .defaultInput)
            })
            .disposed(by: disposeBag)

        oldPasswordTextField.textField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(oldPasswordTextField.textField.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] oldPassword in
                guard let self else { return }
                let isChangingPassword = !(self.newPasswordTextField.textField.text ?? "").isEmpty
                    || !(self.confirmNewPasswordTextField.textField.text ?? "").isEmpty
                let validation = self.presenter.isValidOldPassword(oldPassword, isChangingPassword: isChangingPassword)
                self.oldPasswordTextField.applyState(!validation.0 ? .error(message: validation.1) : .defaultInput)
            })
            .disposed(by: disposeBag)

        newPasswordTextField.textField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(newPasswordTextField.textField.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] password in
                guard let self else { return }
                let validation = self.presenter.isValidNewPassword(password)
                self.newPasswordTextField.applyState(!validation.0 ? .error(message: validation.1) : .defaultInput)
            })
            .disposed(by: disposeBag)

        confirmNewPasswordTextField.textField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(confirmNewPasswordTextField.textField.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] confirmPassword in
                guard let self else { return }
                let newPassword = self.newPasswordTextField.textField.text ?? ""
                let validation = self.presenter.isValidConfirmPassword(confirmPassword, matching: newPassword)
                self.confirmNewPasswordTextField.applyState(!validation.0 ? .error(message: validation.1) : .defaultInput)
            })
            .disposed(by: disposeBag)
    }

    func bindPasswordVisibilityToggle() {
        [oldPasswordTextField, newPasswordTextField, confirmNewPasswordTextField].forEach { field in
            field.onTrailingIconTapped = { [weak self] in
                guard let self else { return }
                self.isPasswordVisible.toggle()
                let iconName = self.isPasswordVisible ? "eye.fill" : "eye.slash.fill"
                self.oldPasswordTextField.textField.isSecureTextEntry = !self.isPasswordVisible
                self.oldPasswordTextField.setTrailingIcon(UIImage(systemName: iconName))
                self.newPasswordTextField.textField.isSecureTextEntry = !self.isPasswordVisible
                self.newPasswordTextField.setTrailingIcon(UIImage(systemName: iconName))
                self.confirmNewPasswordTextField.textField.isSecureTextEntry = !self.isPasswordVisible
                self.confirmNewPasswordTextField.setTrailingIcon(UIImage(systemName: iconName))
            }
        }
    }

    func bindReturnKeyChaining() {
        nameTextField.textField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
                self?.phoneTextField.textField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)

        phoneTextField.textField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
                self?.oldPasswordTextField.textField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)

        oldPasswordTextField.textField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
                self?.newPasswordTextField.textField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)

        newPasswordTextField.textField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
                self?.confirmNewPasswordTextField.textField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)

        confirmNewPasswordTextField.textField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
                self?.submitChanges()
            })
            .disposed(by: disposeBag)
    }

    func submitChanges() {
        guard saveButton.isEnabled else { return }
        view.endEditing(true)
        presenter.saveTapped(
            name: nameTextField.textField.text ?? "",
            phone: phoneTextField.textField.text ?? "",
            oldPassword: oldPasswordTextField.textField.text ?? "",
            newPassword: newPasswordTextField.textField.text ?? "",
            confirmPassword: confirmNewPasswordTextField.textField.text ?? ""
        )
    }

    func updateSaveButtonState() {
        let name = nameTextField.textField.text ?? ""
        let phone = phoneTextField.textField.text ?? ""
        let oldPassword = oldPasswordTextField.textField.text ?? ""
        let newPassword = newPasswordTextField.textField.text ?? ""
        let confirmPassword = confirmNewPasswordTextField.textField.text ?? ""

        let hasProfileChanges = hasAvatarChanged
            || name.trimmingCharacters(in: .whitespacesAndNewlines) != originalName
            || phone.trimmingCharacters(in: .whitespacesAndNewlines) != originalPhone

        let form = EditProfileFormState(name: name,
                                        phone: phone,
                                        oldPassword: oldPassword,
                                        newPassword: newPassword,
                                        confirmPassword: confirmPassword,
                                        hasProfileChanges: hasProfileChanges)
        saveButton.isEnabled = presenter.isSaveEnabled(form)
    }
}

private extension EditProfileView {
    @objc func didTapEditAvatar() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    func handlePickedAvatar(_ image: UIImage) {
        guard let imageData = image.avatarJPEGData() else { return }
        avatarImageView.image = image
        hasAvatarChanged = true
        updateSaveButtonState()
        presenter.updateAvatar(imageData: imageData)
    }
}

extension EditProfileView: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }

        provider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            guard let image = object as? UIImage else { return }
            DispatchQueue.main.async {
                self?.handlePickedAvatar(image)
            }
        }
    }
}

private extension EditProfileView {
    func setupKeyboardHandling() {
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

    func handleKeyboard(notification: Notification, isShowing: Bool) {
        guard
            let userInfo = notification.userInfo,
            let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int
        else { return }

        if isShowing {
            let keyboardFrame = view.convert(frameValue.cgRectValue, from: nil)
            let keyboardHeight = view.bounds.height - keyboardFrame.minY
            saveButtonBottomConstraint?.deactivate()
            saveButtonKeyboardConstraint?.update(offset: -(keyboardHeight + 24))
            saveButtonKeyboardConstraint?.activate()
        } else {
            saveButtonKeyboardConstraint?.deactivate()
            saveButtonBottomConstraint?.activate()
        }

        let options = UIView.AnimationOptions(rawValue: UInt(curveRaw << 16))
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.view.layoutIfNeeded()
        }
    }
}

extension EditProfileView: EditProfileViewProtocol {
    func showLoading() {
        nameTextField.textField.isEnabled = false
        phoneTextField.textField.isEnabled = false
        oldPasswordTextField.textField.isEnabled = false
        newPasswordTextField.textField.isEnabled = false
        confirmNewPasswordTextField.textField.isEnabled = false
        saveButton.isEnabled = false
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        nameTextField.textField.isEnabled = true
        phoneTextField.textField.isEnabled = true
        oldPasswordTextField.textField.isEnabled = true
        newPasswordTextField.textField.isEnabled = true
        confirmNewPasswordTextField.textField.isEnabled = true
        activityIndicator.stopAnimating()
        updateSaveButtonState()
    }

    func prefill(email: String, name: String, phone: String, avatarURL: String?) {
        emailTextField.textField.text = email
        nameTextField.textField.text = name
        phoneTextField.textField.text = phone
        avatarImageView.setImage(from: avatarURL, placeholder: UIImage(systemName: "person.crop.circle.fill"))

        originalName = name
        originalPhone = phone
        hasAvatarChanged = false
        updateSaveButtonState()
    }

    func showToast(_ message: String, style: ToastStyle) {
        ToastView.show(message, style: style, in: view)
    }
}

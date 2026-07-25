//
//  EditProfilePresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 25/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import RxSwift

final class EditProfilePresenter: EditProfilePresenterProtocol {
    weak var view: EditProfileViewProtocol?
    private let interactor: EditProfileInteractorProtocol
    private let router: EditProfileRouterProtocol
    private let disposeBag = DisposeBag()

    private var _editProfileBuilderAction = BehaviorSubject<EditProfileBuilderAction>(value: .cancel)
    private var hasCompleted = false
    private var hasUnsavedChanges = false

    init(interactor: EditProfileInteractorProtocol, router: EditProfileRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    var editProfileBuilderAction: Observable<EditProfileBuilderAction> {
        _editProfileBuilderAction.asObservable()
    }

    func viewDidLoad() {
        interactor.fetchCurrentUser()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] user in
                    self?.view?.prefill(email: user.email, name: user.name, phone: user.phone, avatarURL: user.avatarURL)
                },
                onError: { [weak self] error in
                    self?.view?.showToast(error.localizedDescription, style: .error)
                }
            )
            .disposed(by: disposeBag)
    }

    func isValidName(_ name: String) -> (Bool, String?) {
        let result = Validation.validFullName(name)
        return (result.isValid, result.errorMessage)
    }

    func isValidPhone(_ phone: String) -> (Bool, String?) {
        let result = Validation.validPhone(phone)
        return (result.isValid, result.errorMessage)
    }

    func isValidOldPassword(_ oldPassword: String, isChangingPassword: Bool) -> (Bool, String?) {
        guard isChangingPassword else { return (true, nil) }
        guard !oldPassword.isEmpty else {
            return (false, NSLocalizedString("validation_required_old_password", comment: ""))
        }
        return (true, nil)
    }

    func isValidNewPassword(_ password: String) -> (Bool, String?) {
        guard !password.isEmpty else { return (true, nil) }
        let result = Validation.validPassword(password)
        return (result.isValid, result.errorMessage)
    }

    func isValidConfirmPassword(_ confirmPassword: String, matching newPassword: String) -> (Bool, String?) {
        guard !confirmPassword.isEmpty else { return (true, nil) }
        guard confirmPassword == newPassword else {
            return (false, NSLocalizedString("validation_invalid_password_not_matching", comment: ""))
        }
        return (true, nil)
    }

    func isSaveEnabled(
        name: String,
        phone: String,
        oldPassword: String,
        newPassword: String,
        confirmPassword: String,
        hasProfileChanges: Bool
    ) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPhone = phone.trimmingCharacters(in: .whitespacesAndNewlines)

        let isProfileChangeValid = hasProfileChanges
            && Validation.validFullName(trimmedName).isValid
            && Validation.validPhone(trimmedPhone).isValid

        let isPasswordChangeValid = !oldPassword.isEmpty
            && !newPassword.isEmpty
            && !confirmPassword.isEmpty
            && Validation.validPassword(newPassword).isValid
            && newPassword == confirmPassword

        return isProfileChangeValid || isPasswordChangeValid
    }

    private func isFormValid(
        name: String,
        phone: String,
        oldPassword: String,
        newPassword: String,
        confirmPassword: String
    ) -> Bool {
        guard Validation.validFullName(name).isValid, Validation.validPhone(phone).isValid else { return false }
        guard newPassword.isEmpty == confirmPassword.isEmpty else { return false }
        guard !newPassword.isEmpty else { return true }
        guard !oldPassword.isEmpty else { return false }
        return Validation.validPassword(newPassword).isValid && newPassword == confirmPassword
    }

    func saveTapped(name: String, phone: String, oldPassword: String, newPassword: String, confirmPassword: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPhone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        guard isFormValid(
            name: trimmedName,
            phone: trimmedPhone,
            oldPassword: oldPassword,
            newPassword: newPassword,
            confirmPassword: confirmPassword
        ) else { return }

        view?.showLoading()

        interactor.updateProfile(
            name: trimmedName,
            phone: trimmedPhone,
            oldPassword: oldPassword.isEmpty ? nil : oldPassword,
            newPassword: newPassword.isEmpty ? nil : newPassword
        )
        .observe(on: MainScheduler.instance)
        .subscribe(
            onNext: { [weak self] in
                self?.view?.hideLoading()
                self?.view?.showToast(NSLocalizedString("update_profile_success", comment: ""), style: .success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                    self?.complete(.saved)
                }
            },
            onError: { [weak self] error in
                self?.view?.hideLoading()
                if let editProfileError = error as? EditProfileError, editProfileError == .wrongOldPassword {
                    self?.view?.showToast(NSLocalizedString("update_password_wrong_old_password", comment: ""), style: .error)
                } else {
                    self?.view?.showToast(error.localizedDescription, style: .error)
                }
            }
        )
        .disposed(by: disposeBag)
    }

    func updateAvatar(imageData: Data) {
        interactor.updateAvatar(imageData: imageData)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] _ in
                    self?.hasUnsavedChanges = true
                    self?.view?.showToast(NSLocalizedString("update_avatar_success", comment: ""), style: .success)
                },
                onError: { [weak self] _ in
                    self?.view?.showToast(NSLocalizedString("update_avatar_failed_message", comment: ""), style: .error)
                }
            )
            .disposed(by: disposeBag)
    }

    func dismiss() {
        complete(hasUnsavedChanges ? .saved : .cancel)
    }

    private func complete(_ action: EditProfileBuilderAction) {
        guard !hasCompleted else { return }
        hasCompleted = true
        _editProfileBuilderAction.onNext(action)
        _editProfileBuilderAction.onCompleted()
    }
}

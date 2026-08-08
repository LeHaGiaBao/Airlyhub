//
//  EditProfileInteractor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 25/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import RxSwift

final class EditProfileInteractor: EditProfileInteractorProtocol {
    func fetchCurrentUser() -> Observable<EditProfileUser> {
        Observable.create { observer in
            guard let uid = AuthService.shared.getCurrentUserId() else {
                observer.onError(EditProfileError.notAuthenticated)
                return Disposables.create()
            }

            UserService.shared.fetchUserProfile(uid: uid) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        let profile = EditProfileUser(
                            email: user.email,
                            name: user.name,
                            phone: user.phone,
                            avatarURL: user.avatar
                        )
                        observer.onNext(profile)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            }

            return Disposables.create()
        }
    }

    func updateProfile(name: String, phone: String, oldPassword: String?, newPassword: String?) -> Observable<Void> {
        Observable.create { observer in
            guard let uid = AuthService.shared.getCurrentUserId() else {
                observer.onError(EditProfileError.notAuthenticated)
                return Disposables.create()
            }

            func updateFirestore(_ finish: @escaping (Result<Void, Error>) -> Void) {
                UserService.shared.updateUserProfile(uid: uid, data: ["name": name, "phone": phone]) { result in
                    switch result {
                    case .success:
                        finish(.success(()))
                    case .failure(let error):
                        finish(.failure(error))
                    }
                }
            }

            let finish: (Result<Void, Error>) -> Void = { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        observer.onNext(())
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            }

            if let newPassword, !newPassword.isEmpty {
                AuthService.shared.reauthenticate(password: oldPassword ?? "") { reauthResult in
                    switch reauthResult {
                    case .success:
                        AuthService.shared.updatePassword(newPassword: newPassword) { result in
                            switch result {
                            case .success:
                                updateFirestore(finish)
                            case .failure(let error):
                                finish(.failure(error))
                            }
                        }
                    case .failure:
                        finish(.failure(EditProfileError.wrongOldPassword))
                    }
                }
            } else {
                updateFirestore(finish)
            }

            return Disposables.create()
        }
    }

    func updateAvatar(imageData: Data) -> Observable<String> {
        Observable.create { observer in
            guard let uid = AuthService.shared.getCurrentUserId() else {
                observer.onError(EditProfileError.notAuthenticated)
                return Disposables.create()
            }

            AvatarService.shared.uploadAvatar(uid: uid, imageData: imageData) { uploadResult in
                switch uploadResult {
                case .success(let reference):
                    UserService.shared.updateAvatar(uid: uid, avatarUrl: reference) { updateResult in
                        DispatchQueue.main.async {
                            switch updateResult {
                            case .success:
                                observer.onNext(reference)
                                observer.onCompleted()
                            case .failure(let error):
                                observer.onError(error)
                            }
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        observer.onError(error)
                    }
                }
            }

            return Disposables.create()
        }
    }
}

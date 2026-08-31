//
//  RegisterInteractor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 21/03/2026.
//

import Foundation
import RxSwift

final class RegisterInteractor: RegisterInteractorProtocol {
    private let auth: AuthRepositoryProtocol
    private let users: UserRepositoryProtocol

    init(auth: AuthRepositoryProtocol, users: UserRepositoryProtocol) {
        self.auth = auth
        self.users = users
    }

    func register(name: String, email: String, password: String) -> Observable<Void> {
        Observable.create { [auth, users] observer in
            auth.register(email: email, password: password) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        let emailValue = user.email ?? email
                        let profile = UserModel(uid: user.uid,
                                                email: emailValue,
                                                name: trimmedName,
                                                avatar: "",
                                                phone: "",createdAt: Date())
                        users.createUserProfile(user: profile) { profileResult in
                            DispatchQueue.main.async {
                                switch profileResult {
                                case .success:
                                    observer.onNext(())
                                    observer.onCompleted()
                                case .failure(let error):
                                    _ = auth.logout()
                                    observer.onError(error)
                                }
                            }
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
}

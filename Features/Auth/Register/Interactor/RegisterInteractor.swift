//
//  RegisterInteractor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 21/03/2026.
//

import Foundation
import RxSwift
import FirebaseAuth

final class RegisterInteractor: RegisterInteractorProtocol {
    func register(name: String, email: String, password: String) -> Observable<Void> {
        Observable.create { observer in
            AuthService.shared.register(email: email, password: password) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        let emailValue = user.email ?? email
                        let profile = UserModel(
                            uid: user.uid,
                            email: emailValue,
                            name: trimmedName,
                            avatar: "",
                            phone: "",
                            createdAt: Date()
                        )
                        UserService.shared.createUserProfile(user: profile) { profileResult in
                            DispatchQueue.main.async {
                                switch profileResult {
                                case .success:
                                    observer.onNext(())
                                    observer.onCompleted()
                                case .failure(let error):
                                    _ = AuthService.shared.logout()
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

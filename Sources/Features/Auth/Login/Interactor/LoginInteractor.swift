//
//  LoginInteractor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/12/2025.
//

import Foundation
import RxSwift

final class LoginInteractor: LoginInteractorProtocol {
    private let auth: AuthRepositoryProtocol

    init(auth: AuthRepositoryProtocol) {
        self.auth = auth
    }

    func login(email: String, password: String) -> Observable<Void> {
        Observable.create { [auth] observer in
            auth.login(email: email, password: password) { result in
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
            return Disposables.create()
        }
    }
}

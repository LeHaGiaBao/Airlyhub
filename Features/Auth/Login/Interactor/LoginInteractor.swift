//
//  LoginInteractor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/12/2025.
//

import Foundation
import RxSwift

final class LoginInteractor: LoginInteractorProtocol {
    func login(email: String, password: String) -> Observable<Void> {
        Observable.create { observer in
            AuthService.shared.login(email: email, password: password) { result in
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

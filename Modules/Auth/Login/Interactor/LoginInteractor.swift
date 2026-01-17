//
//  LoginInteractor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/12/2025.
//

import Foundation
import RxSwift

final class LoginInteractor: LoginInteractorProtocol {

    func login(username: String, password: String) -> Observable<Bool> {
        return Observable.just(true)
            .delay(.seconds(1), scheduler: MainScheduler.instance)
    }
}

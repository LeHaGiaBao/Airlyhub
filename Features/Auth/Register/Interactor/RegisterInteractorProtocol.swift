//
//  RegisterInteractorProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import RxSwift

protocol RegisterInteractorProtocol {
    func register(name: String, email: String, password: String) -> Observable<Void>
}

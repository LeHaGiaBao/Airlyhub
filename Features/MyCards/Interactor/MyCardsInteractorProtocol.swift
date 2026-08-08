//
//  MyCardsInteractorProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import RxSwift

protocol MyCardsInteractorProtocol: AnyObject {
    func fetchCards() -> Observable<[CardModel]>
    func addCard(_ input: NewCardInput) -> Observable<Void>
    func deleteCard(id: String) -> Observable<Void>
    func setDefaultCard(id: String) -> Observable<Void>
}

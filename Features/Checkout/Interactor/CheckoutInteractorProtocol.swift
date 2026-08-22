//
//  CheckoutInteractorProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import RxSwift

protocol CheckoutInteractorProtocol: AnyObject {
    func fetchCards() -> Observable<[CardModel]>
    /// Reuses `MyCardsInteractor`'s validation, dedupe and encryption — see the
    /// concrete type for why this isn't reimplemented here.
    func saveCard(_ input: NewCardInput) -> Observable<Void>
    func createBooking(_ draft: BookingDraft,
                       cardLast4: String?,
                       cardBrand: CardBrand?,
                       completion: @escaping (Result<String, Error>) -> Void)
}

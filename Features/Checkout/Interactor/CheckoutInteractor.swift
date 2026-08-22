//
//  CheckoutInteractor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import RxSwift

/// Delegates card work to `MyCardsInteractor` instead of calling `CardService`
/// directly — that type already owns the validation, duplicate check, card-limit
/// check and PAN encryption a save has to go through, and reimplementing any of
/// that here risks the two screens disagreeing about what a valid card is.
final class CheckoutInteractor: CheckoutInteractorProtocol {
    private let bookingRepository: BookingRepositoryProtocol
    private let cardsInteractor: MyCardsInteractorProtocol

    init(bookingRepository: BookingRepositoryProtocol, cardsInteractor: MyCardsInteractorProtocol) {
        self.bookingRepository = bookingRepository
        self.cardsInteractor = cardsInteractor
    }

    func fetchCards() -> Observable<[CardModel]> {
        cardsInteractor.fetchCards()
    }

    func saveCard(_ input: NewCardInput) -> Observable<Void> {
        cardsInteractor.addCard(input)
    }

    func createBooking(_ draft: BookingDraft,
                       cardLast4: String?,
                       cardBrand: CardBrand?,
                       completion: @escaping (Result<String, Error>) -> Void) {
        bookingRepository.create(draft, cardLast4: cardLast4, cardBrand: cardBrand, completion: completion)
    }
}

//
//  CheckoutPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import RxSwift

final class CheckoutPresenter: CheckoutPresenterProtocol {
    private weak var view: CheckoutViewProtocol?
    private let interactor: CheckoutInteractorProtocol
    private let router: CheckoutRouterProtocol
    private let draft: BookingDraft
    private let bag = DisposeBag()

    private var isPaying = false

    init(view: CheckoutViewProtocol,
         interactor: CheckoutInteractorProtocol,
         router: CheckoutRouterProtocol,
         draft: BookingDraft) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.draft = draft
    }

    func viewDidLoad() {
        interactor.fetchCards()
            .subscribe(
                onNext: { [weak self] cards in
                    self?.view?.showSavedCards(cards.filter(\.isSelectable))
                },
                onError: { [weak self] _ in
                    self?.view?.showSavedCards([])
                }
            )
            .disposed(by: bag)
    }

    func didTapBack() {
        router.dismiss()
    }

    func didTapPay(with method: CheckoutPaymentMethod) {
        guard !isPaying else { return }
        isPaying = true
        view?.setPaying(true)

        let cardLast4: String?
        let cardBrand: CardBrand?

        switch method {
        case .savedCard(let card):
            cardLast4 = card.last4
            cardBrand = card.brand

        case .newCard(let input, let save):
            let digits = input.number.filter(\.isNumber)
            cardLast4 = String(digits.suffix(4))
            cardBrand = CardBrand.detect(from: digits)

            if save {
                interactor.saveCard(input)
                    .subscribe(onError: { [weak self] _ in
                        self?.view?.showError(NSLocalizedString("checkout_save_card_failed", comment: ""))
                    })
                    .disposed(by: bag)
            }
        }

        interactor.createBooking(draft, cardLast4: cardLast4, cardBrand: cardBrand) { [weak self] result in
            guard let self else { return }
            self.isPaying = false
            self.view?.setPaying(false)

            switch result {
            case .success:
                self.router.showPaymentSuccess()
            case .failure:
                self.view?.showError(NSLocalizedString("checkout_booking_failed", comment: ""))
            }
        }
    }
}

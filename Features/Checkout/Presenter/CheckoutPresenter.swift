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

    /// Guards against a double tap firing two bookings while the first is still
    /// writing — same role `SearchResultsPresenter.isLoadingMore` plays.
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
                    // A card expired since it was saved, or revoked, cannot pay —
                    // filtered out here rather than shown disabled, since a
                    // payment screen has no "edit later" reason to keep it visible.
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
                // Best-effort: the card is charged either way, so a failed save
                // only loses the convenience of reusing it next time, not the
                // booking itself.
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

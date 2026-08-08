//
//  MyCardsPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import Foundation
import RxSwift

final class MyCardsPresenter: MyCardsPresenterProtocol {
    weak var view: MyCardsViewProtocol?

    private let interactor: MyCardsInteractorProtocol
    private let router: MyCardsRouterProtocol
    private let disposeBag = DisposeBag()

    private var _myCardsBuilderAction = BehaviorSubject<MyCardsBuilderAction>(value: .cancel)
    private var hasCompleted = false
    private var cards: [CardModel] = []

    init(interactor: MyCardsInteractorProtocol,
         router: MyCardsRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    var myCardsBuilderAction: Observable<MyCardsBuilderAction> {
        _myCardsBuilderAction.asObservable()
    }

    func viewDidLoad() {
        loadCards()
    }

    func addCardTapped() {
        router.presentAddCardSheet { [weak self] input in
            self?.submit(input)
        }
    }

    func cardSelected(id: String) {
        guard let card = cards.first(where: { $0.id == id }),
              card.isSelectable,
              !card.isDefault else { return }

        view?.showLoading()

        interactor.setDefaultCard(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] in
                    self?.view?.hideLoading()
                    self?.view?.showToast(
                        NSLocalizedString("set_default_card_success", comment: ""),
                        style: .success
                    )
                    self?.loadCards()
                },
                onError: { [weak self] _ in
                    self?.view?.hideLoading()
                    // Firestore's own error text is unhelpful to a end user here, so
                    // this reports the action that failed instead.
                    self?.view?.showToast(
                        NSLocalizedString("set_default_card_failed", comment: ""),
                        style: .error
                    )
                }
            )
            .disposed(by: disposeBag)
    }

    func deleteRequested(id: String) {
        guard let card = cards.first(where: { $0.id == id }) else { return }

        // Deleting the default card is blocked so the user is never left without a
        // payment method selected — but only while another card could actually take
        // over. If none can (this is the only card, or every other one has expired),
        // "set another card as default first" is impossible to follow and the rule
        // would strand the user with a card they can never remove.
        if card.isDefault, hasAlternativeDefault(excluding: id) {
            view?.showToast(
                NSLocalizedString("delete_card_default_warning", comment: ""),
                style: .info
            )
            return
        }

        // Confirm first, delete after. The swipe gesture never removes anything on its own.
        let title = CardFormatter.masked(last4: card.last4, brand: card.brand)
        router.presentDeleteConfirmation(cardTitle: title) { [weak self] in
            self?.performDelete(id: id)
        }
    }

    func dismiss() {
        guard !hasCompleted else { return }
        hasCompleted = true
        _myCardsBuilderAction.onNext(.cancel)
        _myCardsBuilderAction.onCompleted()
    }
}

// MARK: - Private
private extension MyCardsPresenter {
    func loadCards() {
        view?.render(.loading)

        interactor.fetchCards()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] cards in
                    guard let self else { return }
                    self.cards = cards
                    self.view?.render(.loaded(cards.map(self.makeItem)))
                },
                onError: { [weak self] error in
                    self?.view?.render(.failed(error.localizedDescription))
                }
            )
            .disposed(by: disposeBag)
    }

    func submit(_ input: NewCardInput) {
        view?.showLoading()

        interactor.addCard(input)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] in
                    self?.view?.hideLoading()
                    self?.view?.showToast(NSLocalizedString("add_card_success", comment: ""), style: .success)
                    self?.loadCards()
                },
                onError: { [weak self] error in
                    self?.view?.hideLoading()
                    self?.view?.showToast(error.localizedDescription, style: .error)
                }
            )
            .disposed(by: disposeBag)
    }

    func performDelete(id: String) {
        view?.showLoading()

        interactor.deleteCard(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] in
                    self?.view?.hideLoading()
                    self?.view?.showToast(NSLocalizedString("delete_card_success", comment: ""), style: .success)
                    self?.loadCards()
                },
                onError: { [weak self] error in
                    self?.view?.hideLoading()
                    self?.view?.showToast(error.localizedDescription, style: .error)
                }
            )
            .disposed(by: disposeBag)
    }

    /// Is there another card that could be promoted to default in this one's place?
    /// Expired cards don't count — `cardSelected` refuses to promote them.
    func hasAlternativeDefault(excluding id: String) -> Bool {
        cards.contains { $0.id != id && $0.isSelectable }
    }

    func makeItem(_ card: CardModel) -> CardItem {
        CardItem(
            id: card.id,
            brand: card.brand,
            maskedNumber: CardFormatter.masked(last4: card.last4, brand: card.brand),
            expiryDisplay: card.expiryDisplay,
            isDefault: card.isDefault,
            isExpired: card.isExpired,
            isSelectable: card.isSelectable
        )
    }
}

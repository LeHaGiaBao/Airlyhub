//
//  MyCardsInteractor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import Foundation
import RxSwift

final class MyCardsInteractor: MyCardsInteractorProtocol {
    private let cards: CardRepositoryProtocol
    private let auth: AuthRepositoryProtocol

    init(cards: CardRepositoryProtocol, auth: AuthRepositoryProtocol) {
        self.cards = cards
        self.auth = auth
    }

    func fetchCards() -> Observable<[CardModel]> {
        Observable.create { [cards, auth] observer in
            guard let uid = auth.getCurrentUserId() else {
                observer.onError(MyCardsError.notAuthenticated)
                return Disposables.create()
            }

            cards.fetchCards(uid: uid) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let cards):
                        observer.onNext(cards)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            }

            return Disposables.create()
        }
    }

    func addCard(_ input: NewCardInput) -> Observable<Void> {
        Observable.create { [cards, auth] observer in
            guard let uid = auth.getCurrentUserId() else {
                observer.onError(MyCardsError.notAuthenticated)
                return Disposables.create()
            }

            let digits = input.number.filter(\.isNumber)
            guard CardValidation.validCardNumber(digits).isValid, digits.count >= 4 else {
                observer.onError(MyCardsError.invalidCard)
                return Disposables.create()
            }

            let brand = CardBrand.detect(from: digits)
            let last4 = String(digits.suffix(4))

            // Read existing cards first: the limit and the duplicate check both need them,
            // and the first card added has to become the default.
            cards.fetchCards(uid: uid) { result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async { observer.onError(error) }

                case .success(let existing):
                    guard existing.count < cards.maxCardsPerUser else {
                        DispatchQueue.main.async { observer.onError(MyCardsError.cardLimitReached) }
                        return
                    }

                    // Same brand + last4 + expiry is close enough to catch an accidental
                    // re-add without comparing PANs, which would mean decrypting every card.
                    let isDuplicate = existing.contains {
                        $0.last4 == last4
                            && $0.brand == brand
                            && $0.expMonth == input.expMonth
                            && $0.expYear == input.expYear
                    }
                    guard !isDuplicate else {
                        DispatchQueue.main.async { observer.onError(MyCardsError.duplicatedCard) }
                        return
                    }

                    do {
                        // The PAN is encrypted here and never travels further in the clear.
                        // `input.cvv` is deliberately not referenced — see NewCardInput.
                        let encrypted = try CardCryptoService.shared.encrypt(digits)

                        let newCard = NewCard(
                            userId: uid,
                            brand: brand,
                            last4: last4,
                            holderName: input.holderName,
                            expMonth: input.expMonth,
                            expYear: input.expYear,
                            // The first card a user saves becomes their default.
                            isDefault: existing.isEmpty,
                            encrypted: encrypted
                        )

                        cards.addCard(newCard) { addResult in
                            DispatchQueue.main.async {
                                switch addResult {
                                case .success:
                                    observer.onNext(())
                                    observer.onCompleted()
                                case .failure(let error):
                                    observer.onError(error)
                                }
                            }
                        }
                    } catch {
                        DispatchQueue.main.async { observer.onError(error) }
                    }
                }
            }

            return Disposables.create()
        }
    }

    func deleteCard(id: String) -> Observable<Void> {
        Observable.create { [cards, auth] observer in
            // The delete is still gated on being signed in; the rules then check that
            // the document's `userId` matches the caller before allowing it through.
            guard auth.getCurrentUserId() != nil else {
                observer.onError(MyCardsError.notAuthenticated)
                return Disposables.create()
            }

            cards.deleteCard(cardId: id) { result in
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

    func setDefaultCard(id: String) -> Observable<Void> {
        Observable.create { [cards, auth] observer in
            guard let uid = auth.getCurrentUserId() else {
                observer.onError(MyCardsError.notAuthenticated)
                return Disposables.create()
            }

            cards.setDefaultCard(uid: uid, cardId: id) { result in
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

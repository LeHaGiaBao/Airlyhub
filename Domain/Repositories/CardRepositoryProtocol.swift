//
//  CardRepositoryProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 31/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// The saved-cards store, as the feature layer sees it.
///
/// Same intent as `TourRepositoryProtocol` / `AuthRepositoryProtocol`: `CardService`
/// over Firestore is the only implementation today, but the interactor talks to
/// this protocol so the query building, the `userId` scoping and the DTO assembly
/// all stay in `Data`.
protocol CardRepositoryProtocol: AnyObject {
    /// Guard rail against a runaway client filling the collection — the interactor
    /// checks a save against this before writing.
    var maxCardsPerUser: Int { get }

    func fetchCards(uid: String,
                    completion: @escaping (Result<[CardModel], Error>) -> Void)

    /// Builds and writes the `cards/{id}` document; returns the new id.
    func addCard(_ newCard: NewCard,
                 completion: @escaping (Result<String, Error>) -> Void)

    func deleteCard(cardId: String,
                    completion: @escaping (Result<Bool, Error>) -> Void)

    /// Clears the previous default and sets the new one in a single batch, so the
    /// list is never observed with two defaults (or none) in between writes.
    func setDefaultCard(uid: String,
                        cardId: String,
                        completion: @escaping (Result<Bool, Error>) -> Void)
}

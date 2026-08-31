//
//  CardRepositoryProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 31/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// The saved-cards store, as the feature layer sees it.
protocol CardRepositoryProtocol: AnyObject {
    var maxCardsPerUser: Int { get }

    func fetchCards(uid: String,
                    completion: @escaping (Result<[CardModel], Error>) -> Void)

    func addCard(_ newCard: NewCard,
                 completion: @escaping (Result<String, Error>) -> Void)

    func deleteCard(cardId: String,
                    completion: @escaping (Result<Bool, Error>) -> Void)

    func setDefaultCard(uid: String,
                        cardId: String,
                        completion: @escaping (Result<Bool, Error>) -> Void)
}

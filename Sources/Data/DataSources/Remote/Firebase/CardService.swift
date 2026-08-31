//
//  CardService.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import FirebaseFirestore

/// CRUD over the top-level `cards` collection, scoped by each document's `userId`.
final class CardService: CardRepositoryProtocol {
    static let shared = CardService()

    var maxCardsPerUser: Int { CardPolicy.maxPerUser }

    private let db = Firestore.firestore()

    private init() {}

    private var cardsCollection: CollectionReference {
        db.collection(FirestoreCollection.cards)
    }

    private func cardsQuery(uid: String) -> Query {
        cardsCollection.whereField("userId", isEqualTo: uid)
    }

    func fetchCards(uid: String, completion: @escaping (Result<[CardModel], Error>) -> Void) {
        cardsQuery(uid: uid)
            .order(by: "createdAt", descending: false)
            .getDocuments { snapshot, error in
                if let error {
                    completion(.failure(error))
                    return
                }

                let cards = snapshot?.documents.compactMap { document -> CardModel? in
                    guard let dto = try? document.data(as: CardDTO.self) else { return nil }
                    return dto.toDomain(id: document.documentID)
                } ?? []

                completion(.success(cards))
            }
    }

    func addCard(_ newCard: NewCard, completion: @escaping (Result<String, Error>) -> Void) {
        let dto = CardDTO.make(
            CardDTO.Draft(
                userId: newCard.userId,
                brand: newCard.brand,
                last4: newCard.last4,
                holderName: newCard.holderName,
                expMonth: newCard.expMonth,
                expYear: newCard.expYear,
                isDefault: newCard.isDefault
            ),
            token: newCard.token,
            encrypted: newCard.encrypted
        )

        do {
            let document = cardsCollection.document()
            try document.setData(from: dto) { error in
                if let error {
                    completion(.failure(error))
                    return
                }
                completion(.success(document.documentID))
            }
        } catch {
            completion(.failure(error))
        }
    }

    func deleteCard(cardId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        cardsCollection
            .document(cardId)
            .delete { error in
                if let error {
                    completion(.failure(error))
                    return
                }
                completion(.success(true))
            }
    }

    func setDefaultCard(uid: String, cardId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        cardsQuery(uid: uid)
            .whereField("isDefault", isEqualTo: true)
            .getDocuments { [weak self] snapshot, error in
                guard let self else { return }
                if let error {
                    completion(.failure(error))
                    return
                }

                let batch = self.db.batch()

                snapshot?.documents
                    .filter { $0.documentID != cardId }
                    .forEach { document in
                        batch.updateData(
                            ["isDefault": false, "updatedAt": FieldValue.serverTimestamp()],
                            forDocument: document.reference
                        )
                    }

                batch.updateData(
                    ["isDefault": true, "updatedAt": FieldValue.serverTimestamp()],
                    forDocument: self.cardsCollection.document(cardId)
                )

                batch.commit { error in
                    if let error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(true))
                }
            }
    }
}

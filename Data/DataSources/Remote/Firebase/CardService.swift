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
///
/// Every query here **must** carry the `userId` equality filter. The security rules
/// evaluate `list` against each document a query would return, so an unfiltered read
/// is rejected outright rather than quietly returning an empty result — the filter is
/// load-bearing for access control, not just for correctness.
///
/// Requires the composite index `userId ASC, createdAt ASC` (see firestore.indexes.json).
final class CardService {
    static let shared = CardService()

    /// Guard rail against a runaway client filling the collection.
    static let maxCardsPerUser = 5

    private let db = Firestore.firestore()

    private init() {}

    private var cardsCollection: CollectionReference {
        db.collection(FirestoreCollection.cards)
    }

    private func cardsQuery(uid: String) -> Query {
        cardsCollection.whereField("userId", isEqualTo: uid)
    }

    // MARK: READ Cards
    func fetchCards(uid: String, completion: @escaping (Result<[CardModel], Error>) -> Void) {
        cardsQuery(uid: uid)
            .order(by: "createdAt", descending: false)
            .getDocuments { snapshot, error in
                if let error {
                    completion(.failure(error))
                    return
                }

                let cards = snapshot?.documents.compactMap { document -> CardModel? in
                    // A single malformed document shouldn't blank the whole list.
                    guard let dto = try? document.data(as: CardDTO.self) else { return nil }
                    return dto.toDomain(id: document.documentID)
                } ?? []

                completion(.success(cards))
            }
    }

    // MARK: CREATE Card
    func addCard(card: CardDTO, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let document = cardsCollection.document()
            try document.setData(from: card) { error in
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

    // MARK: DELETE Card
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

    // MARK: UPDATE Default Card
    /// Clears the previous default and sets the new one in a single batch, so the
    /// list can never be observed with two defaults (or none) in between writes.
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

//
//  BookingService.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum BookingError: LocalizedError {
    case notAuthenticated

    var errorDescription: String? {
        NSLocalizedString("error_not_authenticated", comment: "")
    }
}

final class BookingService: BookingRepositoryProtocol {
    static let shared = BookingService()

    private let db = Firestore.firestore()

    private init() {}

    private var bookingsCollection: CollectionReference {
        db.collection(FirestoreCollection.bookings)
    }

    private func bookingsQuery(uid: String) -> Query {
        bookingsCollection.whereField("userId", isEqualTo: uid)
    }

    func create(_ draft: BookingDraft,
                cardLast4: String?,
                cardBrand: CardBrand?,
                completion: @escaping (Result<String, Error>) -> Void) {
        guard let uid = AuthService.shared.getCurrentUserId() else {
            completion(.failure(BookingError.notAuthenticated))
            return
        }

        let dto = BookingDTO.make(draft: draft, userId: uid, cardLast4: cardLast4, cardBrand: cardBrand)

        do {
            let document = bookingsCollection.document()
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

    func fetchBookings(completion: @escaping (Result<[BookingModel], Error>) -> Void) {
        guard let uid = AuthService.shared.getCurrentUserId() else {
            completion(.failure(BookingError.notAuthenticated))
            return
        }

        bookingsQuery(uid: uid)
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                if let error {
                    completion(.failure(error))
                    return
                }

                let bookings = snapshot?.documents.compactMap { document -> BookingModel? in
                    guard let dto = try? document.data(as: BookingDTO.self) else { return nil }
                    return dto.toDomain(id: document.documentID)
                } ?? []

                completion(.success(bookings))
            }
    }
}

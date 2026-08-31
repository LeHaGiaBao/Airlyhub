//
//  ChatService.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import FirebaseFirestore

/// Reads and writes the support thread at `conversations/{uid}`.
final class ChatService: ChatRepositoryProtocol {
    static let shared = ChatService()

    static let messagePageSize = 50

    private let db = Firestore.firestore()

    private init() {}

    private func conversationRef(uid: String) -> DocumentReference {
        db.collection(FirestoreCollection.conversations).document(uid)
    }

    private func messagesRef(uid: String) -> CollectionReference {
        conversationRef(uid: uid).collection(FirestoreCollection.messages)
    }

    func observeMessages(uid: String,
                         onChange: @escaping (Result<[ChatMessageModel], Error>) -> Void) -> ChatSubscription {
        let registration = messagesRef(uid: uid)
            .order(by: "createdAt", descending: true)
            .limit(to: Self.messagePageSize)
            .addSnapshotListener { snapshot, error in
                if let error {
                    onChange(.failure(error))
                    return
                }

                guard let snapshot else {
                    onChange(.success([]))
                    return
                }

                let messages = snapshot.documents.compactMap { document -> ChatMessageModel? in
                    guard let dto = try? document.data(as: ChatMessageDTO.self, with: .estimate) else { return nil }
                    let message = dto.toDomain(id: document.documentID,
                                               isPending: document.metadata.hasPendingWrites)
                    return message.isEmpty ? nil : message
                }

                onChange(.success(messages.reversed()))
            }

        return ChatSubscription { registration.remove() }
    }

    func loadOrCreateConversation(uid: String,
                                  userName: String?,
                                  userEmail: String?,
                                  completion: @escaping (Result<ChatConversationModel, Error>) -> Void) {
        let reference = conversationRef(uid: uid)

        reference.getDocument { [weak self] snapshot, error in
            if let error {
                completion(.failure(error))
                return
            }

            if let snapshot, snapshot.exists,
               let dto = try? snapshot.data(as: ChatConversationDTO.self, with: .estimate) {
                completion(.success(dto.toDomain(id: uid)))
                return
            }

            self?.createConversation(uid: uid,
                                     userName: userName,
                                     userEmail: userEmail,
                                     completion: completion)
        }
    }

    func sendMessage(uid: String,
                     _ message: OutgoingChatMessage,
                     completion: @escaping (Result<Void, Error>) -> Void) {
        let dto = ChatMessageDTO.make(
            senderId: uid,
            text: message.text,
            attachments: message.attachments.map { ChatAttachmentDTO($0) }
        )

        do {
            let document = messagesRef(uid: uid).document()
            try document.setData(from: dto) { [weak self] error in
                if let error {
                    completion(.failure(error))
                    return
                }
                self?.updateSummary(uid: uid, message: dto)
                completion(.success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }
}

private extension ChatService {
    func createConversation(uid: String,
                            userName: String?,
                            userEmail: String?,
                            completion: @escaping (Result<ChatConversationModel, Error>) -> Void) {
        let reference = conversationRef(uid: uid)
        let dto = ChatConversationDTO.make(userId: uid, userName: userName, userEmail: userEmail)

        do {
            try reference.setData(from: dto) { error in
                if let error {
                    completion(.failure(error))
                    return
                }
                reference.getDocument { snapshot, error in
                    if let error {
                        completion(.failure(error))
                        return
                    }
                    guard let snapshot,
                          let saved = try? snapshot.data(as: ChatConversationDTO.self, with: .estimate) else {
                        completion(.failure(ChatServiceError.conversationUnavailable))
                        return
                    }
                    completion(.success(saved.toDomain(id: uid)))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    func updateSummary(uid: String, message: ChatMessageDTO) {
        let preview = message.text.isEmpty
            ? NSLocalizedString("chat_attachment_preview", comment: "")
            : String(message.text.prefix(120))

        conversationRef(uid: uid).setData(
            [
                "lastMessage": preview,
                "lastSenderRole": message.senderRole,
                "lastMessageAt": FieldValue.serverTimestamp()
            ],
            merge: true
        )
    }
}

enum ChatServiceError: LocalizedError {
    case conversationUnavailable

    var errorDescription: String? {
        switch self {
        case .conversationUnavailable:
            return NSLocalizedString("chat_load_failed", comment: "")
        }
    }
}

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
///
/// Unlike `CardService`, which fetches once per screen, this one *listens*: the
/// operator's replies have to land without the user pulling to refresh. Every
/// listener returns its `ListenerRegistration` — the caller owns it and must remove
/// it, or it keeps billing reads and retaining the callback for the app's lifetime.
///
/// Access control is the document path, not a field: `conversations/{uid}` is only
/// readable by `uid` (or a support operator). That also means the `messages` query
/// needs no composite index — a single-field `createdAt` index is created automatically.
final class ChatService {
    static let shared = ChatService()

    /// How much of the thread is kept live. Older messages stay in Firestore; the
    /// listener window is capped so a long history doesn't re-read on every change.
    static let messagePageSize = 50

    /// Mirrored by the security rules, which reject anything longer.
    static let maxMessageLength = 4000

    private let db = Firestore.firestore()

    private init() {}

    private func conversationRef(uid: String) -> DocumentReference {
        db.collection(FirestoreCollection.conversations).document(uid)
    }

    private func messagesRef(uid: String) -> CollectionReference {
        conversationRef(uid: uid).collection(FirestoreCollection.messages)
    }

    // MARK: OBSERVE Messages
    /// Streams the newest `limit` messages, oldest-first, and re-fires on every change.
    ///
    /// The query orders newest-first so the window keeps the *recent* end of a long
    /// thread, then the result is reversed for display. A message the user just sent
    /// is still waiting for its server timestamp, but Firestore's local cache sorts a
    /// pending timestamp above every real one, so it stays inside the window and lands
    /// at the bottom rather than being dropped or jumping to the top.
    ///
    /// - Returns: the registration to remove when the screen goes away.
    func observeMessages(uid: String,
                         limit: Int = ChatService.messagePageSize,
                         onChange: @escaping (Result<[ChatMessageModel], Error>) -> Void) -> ListenerRegistration {
        messagesRef(uid: uid)
            .order(by: "createdAt", descending: true)
            .limit(to: limit)
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
                    // `.estimate` fills a not-yet-acknowledged server timestamp with the
                    // local clock, so a just-sent bubble shows a time immediately instead
                    // of a blank that fills in a moment later.
                    guard let dto = try? document.data(as: ChatMessageDTO.self, with: .estimate) else { return nil }
                    let message = dto.toDomain(id: document.documentID,
                                               isPending: document.metadata.hasPendingWrites)
                    // A single malformed document shouldn't punch a hole in the thread.
                    return message.isEmpty ? nil : message
                }

                onChange(.success(messages.reversed()))
            }
    }

    // MARK: READ or CREATE Conversation
    /// Fetches the thread header, creating it on first visit.
    ///
    /// Called when the screen opens rather than on first send, so `createdAt` marks
    /// when the user actually arrived — the greeting is anchored to it — and an
    /// operator can see someone is waiting even before they type.
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

    // MARK: SEND Message
    /// Writes a message to the thread.
    ///
    /// The bubble does not wait on this: Firestore applies the write to its local cache
    /// straight away, so `observeMessages` fires with the new message before the server
    /// has seen it. `completion` reports the *server* outcome only — offline it stays
    /// silent until connectivity returns, which is why the caller must not gate the UI
    /// on it and must only use it to surface a failure.
    func sendMessage(uid: String,
                     message: ChatMessageDTO,
                     completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let document = messagesRef(uid: uid).document()
            try document.setData(from: message) { [weak self] error in
                if let error {
                    completion(.failure(error))
                    return
                }
                self?.updateSummary(uid: uid, message: message)
                completion(.success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }
}

// MARK: - Private
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
                // Read back rather than returning `dto`: `createdAt` is a server
                // timestamp and is still nil in the object that was just written.
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

    /// Denormalizes the newest message onto the thread header so an operator's inbox can
    /// preview and sort threads by reading one document each.
    ///
    /// Deliberately fire-and-forget: this is a convenience for the operator side, and the
    /// message itself is already safely written. Failing the send because the preview
    /// didn't update would be the wrong trade. On the free plan there is no Cloud Function
    /// to do this server-side, so the client maintains it and the rules restrict the write
    /// to exactly these three fields.
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

// MARK: - Errors
enum ChatServiceError: LocalizedError {
    case conversationUnavailable

    var errorDescription: String? {
        switch self {
        case .conversationUnavailable:
            return NSLocalizedString("chat_load_failed", comment: "")
        }
    }
}

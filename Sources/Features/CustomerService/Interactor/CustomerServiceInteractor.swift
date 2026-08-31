//
//  CustomerServiceInteractor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import Foundation
import RxSwift

final class CustomerServiceInteractor: CustomerServiceInteractorProtocol {
    private let chat: ChatRepositoryProtocol
    private let attachments: ChatAttachmentRepositoryProtocol
    private let auth: AuthRepositoryProtocol

    init(chat: ChatRepositoryProtocol,
         attachments: ChatAttachmentRepositoryProtocol,
         auth: AuthRepositoryProtocol) {
        self.chat = chat
        self.attachments = attachments
        self.auth = auth
    }

    func loadConversation() -> Observable<ChatConversationModel> {
        Observable.create { [chat, auth] observer in
            guard let uid = auth.getCurrentUserId() else {
                observer.onError(CustomerServiceError.notAuthenticated)
                return Disposables.create()
            }

            chat.loadOrCreateConversation(
                uid: uid,
                userName: auth.getCurrentUserName(),
                userEmail: auth.getCurrentUserEmail()
            ) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let conversation):
                        observer.onNext(conversation)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            }

            return Disposables.create()
        }
    }

    func observeMessages() -> Observable<[ChatMessageModel]> {
        Observable.create { [chat, auth] observer in
            guard let uid = auth.getCurrentUserId() else {
                observer.onError(CustomerServiceError.notAuthenticated)
                return Disposables.create()
            }

            let subscription = chat.observeMessages(uid: uid) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let messages):
                        observer.onNext(messages)
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            }

            return Disposables.create { subscription.remove() }
        }
    }

    func sendMessage(text: String, attachment: ChatAttachmentDraft?) -> Observable<Void> {
        Observable.create { [chat, attachments, auth] observer in
            guard let uid = auth.getCurrentUserId() else {
                observer.onError(CustomerServiceError.notAuthenticated)
                return Disposables.create()
            }

            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

            guard !trimmed.isEmpty || attachment != nil else {
                observer.onError(CustomerServiceError.emptyMessage)
                return Disposables.create()
            }

            guard trimmed.count <= ChatPolicy.maxMessageLength else {
                observer.onError(CustomerServiceError.messageTooLong)
                return Disposables.create()
            }

            let write: ([ChatAttachment]) -> Void = { files in
                chat.sendMessage(uid: uid, OutgoingChatMessage(text: trimmed, attachments: files)) { result in
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
            }

            guard let attachment else {
                write([])
                return Disposables.create()
            }

            guard attachments.isAvailable else {
                observer.onError(CustomerServiceError.attachmentsUnavailable)
                return Disposables.create()
            }

            guard attachment.data.count <= CustomerServiceLimits.maxAttachmentBytes else {
                observer.onError(CustomerServiceError.attachmentTooLarge)
                return Disposables.create()
            }

            attachments.upload(
                uid: uid,
                attachmentId: UUID().uuidString,
                data: attachment.data
            ) { result in
                switch result {
                case .success(let path):
                    let file = ChatAttachment(
                        path: path,
                        name: attachment.name,
                        contentType: attachment.contentType,
                        size: attachment.data.count
                    )
                    write([file])

                case .failure:
                    DispatchQueue.main.async {
                        observer.onError(CustomerServiceError.attachmentUploadFailed)
                    }
                }
            }

            return Disposables.create()
        }
    }
}

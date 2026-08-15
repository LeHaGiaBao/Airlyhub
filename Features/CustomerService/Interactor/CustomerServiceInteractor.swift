//
//  CustomerServiceInteractor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import Foundation
import RxSwift

final class CustomerServiceInteractor: CustomerServiceInteractorProtocol {

    func loadConversation() -> Observable<ChatConversationModel> {
        Observable.create { observer in
            guard let uid = AuthService.shared.getCurrentUserId() else {
                observer.onError(CustomerServiceError.notAuthenticated)
                return Disposables.create()
            }

            // Name and email are copied onto the thread so an operator reading it in the
            // Firebase console sees who they're talking to without a second lookup.
            ChatService.shared.loadOrCreateConversation(
                uid: uid,
                userName: AuthService.shared.getCurrentUserName(),
                userEmail: AuthService.shared.getCurrentUserEmail()
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
        Observable.create { observer in
            guard let uid = AuthService.shared.getCurrentUserId() else {
                observer.onError(CustomerServiceError.notAuthenticated)
                return Disposables.create()
            }

            let registration = ChatService.shared.observeMessages(uid: uid) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let messages):
                        // Deliberately no `onCompleted`: this stream stays open for the
                        // life of the screen so later replies keep arriving.
                        observer.onNext(messages)
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            }

            // Without this the listener outlives the screen, billing reads forever and
            // retaining the observer along with it.
            return Disposables.create { registration.remove() }
        }
    }

    func sendMessage(text: String, attachment: ChatAttachmentDraft?) -> Observable<Void> {
        Observable.create { observer in
            guard let uid = AuthService.shared.getCurrentUserId() else {
                observer.onError(CustomerServiceError.notAuthenticated)
                return Disposables.create()
            }

            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

            guard !trimmed.isEmpty || attachment != nil else {
                observer.onError(CustomerServiceError.emptyMessage)
                return Disposables.create()
            }

            // Mirrors the rules' own length check, so an over-long message is refused
            // here with a readable message instead of coming back as a permission error.
            guard trimmed.count <= ChatService.maxMessageLength else {
                observer.onError(CustomerServiceError.messageTooLong)
                return Disposables.create()
            }

            guard let attachment else {
                self.write(uid: uid, text: trimmed, attachments: [], observer: observer)
                return Disposables.create()
            }

            // Checked before the size test so a build without Realtime Database reports
            // the real reason rather than blaming the user's photo.
            guard ChatAttachmentService.shared.isAvailable else {
                observer.onError(CustomerServiceError.attachmentsUnavailable)
                return Disposables.create()
            }

            guard attachment.data.count <= CustomerServiceLimits.maxAttachmentBytes else {
                observer.onError(CustomerServiceError.attachmentTooLarge)
                return Disposables.create()
            }

            // The payload has to be stored before the message that references it is
            // written — otherwise the thread would briefly show a broken attachment.
            ChatAttachmentService.shared.upload(
                uid: uid,
                attachmentId: UUID().uuidString,
                data: attachment.data
            ) { result in
                switch result {
                case .success(let path):
                    let dto = ChatAttachmentDTO(
                        path: path,
                        name: attachment.name,
                        contentType: attachment.contentType,
                        size: attachment.data.count
                    )
                    self.write(uid: uid, text: trimmed, attachments: [dto], observer: observer)

                case .failure:
                    // Database errors are opaque to a user (permission codes, quota text);
                    // report what failed instead of forwarding them.
                    DispatchQueue.main.async {
                        observer.onError(CustomerServiceError.attachmentUploadFailed)
                    }
                }
            }

            return Disposables.create()
        }
    }
}

// MARK: - Private
private extension CustomerServiceInteractor {
    func write(uid: String,
               text: String,
               attachments: [ChatAttachmentDTO],
               observer: AnyObserver<Void>) {
        let message = ChatMessageDTO.make(senderId: uid, text: text, attachments: attachments)

        ChatService.shared.sendMessage(uid: uid, message: message) { result in
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
}

//
//  CustomerServicePresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import Foundation
import RxSwift

final class CustomerServicePresenter: CustomerServicePresenterProtocol {
    weak var view: CustomerServiceViewProtocol?

    private let interactor: CustomerServiceInteractorProtocol
    private let router: CustomerServiceRouterProtocol
    private let disposeBag = DisposeBag()

    private var _customerServiceBuilderAction = BehaviorSubject<CustomerServiceBuilderAction>(value: .cancel)
    private var hasCompleted = false

    private var conversation: ChatConversationModel?
    private var messages: [ChatMessageModel] = []

    init(interactor: CustomerServiceInteractorProtocol,
         router: CustomerServiceRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    var customerServiceBuilderAction: Observable<CustomerServiceBuilderAction> {
        _customerServiceBuilderAction.asObservable()
    }

    func viewDidLoad() {
        view?.render(.loading)
        loadConversation()
    }

    func sendTapped(text: String, attachment: ChatAttachmentDraft?) {
        let isUploading = attachment != nil
        if isUploading {
            view?.setSending(true)
        } else {
            view?.clearInput()
        }

        interactor.sendMessage(text: text, attachment: attachment)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] in
                    guard let self else { return }
                    if isUploading {
                        self.view?.setSending(false)
                        self.view?.clearInput()
                    }
                },
                onError: { [weak self] error in
                    guard let self else { return }
                    self.view?.setSending(false)
                    self.view?.showToast(self.message(for: error), style: .error)
                }
            )
            .disposed(by: disposeBag)
    }

    func dismiss() {
        guard !hasCompleted else { return }
        hasCompleted = true
        _customerServiceBuilderAction.onNext(.cancel)
        _customerServiceBuilderAction.onCompleted()
    }
}

private extension CustomerServicePresenter {
    func loadConversation() {
        interactor.loadConversation()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] conversation in
                    self?.conversation = conversation
                    self?.observeMessages()
                },
                onError: { [weak self] error in
                    guard let self else { return }
                    self.view?.render(.failed(self.message(for: error)))
                }
            )
            .disposed(by: disposeBag)
    }

    func observeMessages() {
        view?.render(.loaded(buildItems()))

        interactor.observeMessages()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] messages in
                    guard let self else { return }
                    self.messages = messages
                    self.view?.render(.loaded(self.buildItems()))
                },
                onError: { [weak self] error in
                    guard let self else { return }
                    self.view?.showToast(self.message(for: error), style: .error)
                }
            )
            .disposed(by: disposeBag)
    }
}

private extension CustomerServicePresenter {
    func buildItems() -> [ChatItem] {
        var items: [ChatItem] = []
        var lastDayKey: Date?

        for bubble in [greetingBubble()] + messages.map(makeBubble) {
            if let day = bubble.day, day != lastDayKey {
                items.append(.daySeparator(id: "day-\(day.timeIntervalSince1970)",
                                           title: ChatFormatter.daySeparator(day)))
                lastDayKey = day
            }
            items.append(.message(bubble.item))
        }

        return items
    }

    func greetingBubble() -> (item: ChatBubbleItem, day: Date?) {
        let createdAt = conversation?.createdAt
        let anchor = createdAt ?? Date()

        let item = ChatBubbleItem(
            id: "greeting",
            text: ChatFormatter.greeting(at: anchor),
            attachments: [],
            timeText: createdAt.map(ChatFormatter.time) ?? "",
            isOutgoing: false,
            isPending: false
        )
        return (item, createdAt.map(ChatFormatter.dayKey))
    }

    func makeBubble(_ message: ChatMessageModel) -> (item: ChatBubbleItem, day: Date?) {
        let item = ChatBubbleItem(
            id: message.id,
            text: message.text,
            attachments: message.attachments,
            timeText: message.createdAt.map(ChatFormatter.time) ?? "",
            isOutgoing: message.isOutgoing,
            isPending: message.isPending
        )
        return (item, message.createdAt.map(ChatFormatter.dayKey))
    }

    func message(for error: Error) -> String {
        if let known = error as? CustomerServiceError {
            return known.errorDescription ?? NSLocalizedString("chat_send_failed", comment: "")
        }
        return NSLocalizedString("chat_send_failed", comment: "")
    }
}

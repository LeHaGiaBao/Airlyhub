//
//  ChatInputBar.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

/// The compose bar pinned to the bottom of the support thread.
final class ChatInputBar: UIView {
    private enum Metric {
        static let containerInset: CGFloat = 16
        static let containerCornerRadius: CGFloat = 12
        static let minTextHeight: CGFloat = 24
        static let maxTextHeight: CGFloat = 96
        static let iconSize: CGFloat = 24
        static let verticalPadding: CGFloat = 12
    }

    var onSend: ((String) -> Void)?
    var onAttach: (() -> Void)?

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Metric.containerCornerRadius
        view.layer.borderWidth = 1
        return view
    }()

    private let emojiButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(AssetsIcon.smileyWink, for: .normal)
        button.tintColor = AppColor.PrimaryColors.Gray.color400
        return button
    }()

    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = TypographyStyle.textSm(weight: .regular).font
        textView.textColor = AppColor.PrimaryColors.Gray.color900
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.returnKeyType = .default
        return textView
    }()

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.PrimaryColors.Gray.color400
        label.text = NSLocalizedString("chat_input_placeholder", comment: "")
        label.applyTypography(.textSm(weight: .regular))
        return label
    }()

    private let attachButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.tintColor = AppColor.PrimaryColors.Gray.color400
        return button
    }()

    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.tintColor = AppColor.PrimaryColors.Primary.color500
        button.isHidden = true
        return button
    }()

    private let sendingIndicator = UIActivityIndicatorView(style: .medium)

    private var textHeightConstraint: Constraint?

    var text: String {
        textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
        updateAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func clear() {
        textView.text = ""
        textViewDidChange(textView)
    }

    func setSending(_ isSending: Bool) {
        isUserInteractionEnabled = !isSending
        sendButton.isHidden = isSending || text.isEmpty
        attachButton.isEnabled = !isSending

        if isSending {
            sendingIndicator.startAnimating()
        } else {
            sendingIndicator.stopAnimating()
        }
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        textView.resignFirstResponder()
    }
}

private extension ChatInputBar {
    func setupUI() {
        backgroundColor = .white

        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(
                UIEdgeInsets(top: 8, left: Metric.containerInset, bottom: 8, right: Metric.containerInset)
            )
        }

        containerView.addSubview(emojiButton)
        emojiButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().inset(Metric.verticalPadding)
            make.size.equalTo(Metric.iconSize)
        }

        containerView.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(Metric.verticalPadding)
            make.size.equalTo(Metric.iconSize)
        }

        containerView.addSubview(sendingIndicator)
        sendingIndicator.snp.makeConstraints { make in
            make.center.equalTo(sendButton)
        }

        containerView.addSubview(attachButton)
        attachButton.snp.makeConstraints { make in
            make.trailing.equalTo(sendButton.snp.leading).offset(-12)
            make.bottom.equalToSuperview().inset(Metric.verticalPadding)
            make.size.equalTo(Metric.iconSize)
        }

        containerView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.leading.equalTo(emojiButton.snp.trailing).offset(8)
            make.trailing.equalTo(attachButton.snp.leading).offset(-8)
            make.top.bottom.equalToSuperview().inset(Metric.verticalPadding)
            textHeightConstraint = make.height.equalTo(Metric.minTextHeight).constraint
        }

        textView.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }

        textView.delegate = self
    }

    func setupActions() {
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        attachButton.addTarget(self, action: #selector(attachTapped), for: .touchUpInside)
        emojiButton.addTarget(self, action: #selector(emojiTapped), for: .touchUpInside)
    }

    func updateAppearance() {
        let isActive = textView.isFirstResponder || !text.isEmpty

        containerView.backgroundColor = isActive ? .white : AppColor.PrimaryColors.Gray.color50
        containerView.layer.borderColor = isActive
            ? (AppColor.PrimaryColors.Primary.color500 ?? .systemBlue).cgColor
            : UIColor.clear.cgColor
    }

    @objc func sendTapped() {
        let message = text
        guard !message.isEmpty else { return }

        FeedbackGenerator.onFeedbackGenerator(.soft)
        onSend?(message)
    }

    @objc func attachTapped() {
        FeedbackGenerator.onFeedbackGenerator(.soft)
        onAttach?()
    }

    @objc func emojiTapped() {
        textView.becomeFirstResponder()
    }
}

extension ChatInputBar: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        sendButton.isHidden = text.isEmpty
        updateAppearance()

        let fitting = textView.sizeThatFits(
            CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude)
        ).height
        let height = min(max(fitting, Metric.minTextHeight), Metric.maxTextHeight)

        textView.isScrollEnabled = fitting > Metric.maxTextHeight
        textHeightConstraint?.update(offset: height)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        updateAppearance()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        updateAppearance()
    }
}

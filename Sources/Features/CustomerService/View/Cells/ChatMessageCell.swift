//
//  ChatMessageCell.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

/// One chat bubble with its timestamp beside it.
final class ChatMessageCell: UITableViewCell {
    static let reuseIdentifier = "ChatMessageCell"

    private enum Metric {
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 4
        static let maxBubbleWidthRatio: CGFloat = 0.72
        static let bubbleCornerRadius: CGFloat = 12
        static let timeSpacing: CGFloat = 8
        static let attachmentHeight: CGFloat = 160
    }

    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Metric.bubbleCornerRadius
        view.clipsToBounds = true
        return view
    }()

    private let attachmentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = AppColor.PrimaryColors.Gray.color200
        return imageView
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.PrimaryColors.Gray.color400
        return label
    }()

    private var attachmentHeightConstraint: Constraint?

    private var pendingAttachmentPath: String?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        attachmentImageView.image = nil
        pendingAttachmentPath = nil
    }

    func configure(with item: ChatBubbleItem,
                   maxWidth: CGFloat,
                   loadAttachment: ChatAttachmentLoader) {
        bubbleView.backgroundColor = item.isOutgoing
            ? AppColor.PrimaryColors.Primary.color700
            : AppColor.PrimaryColors.Primary.color500

        bubbleView.alpha = item.isPending ? 0.6 : 1

        messageLabel.isHidden = !item.hasText
        if item.hasText {
            messageLabel.textAlignment = .natural
            messageLabel.text = item.text
            messageLabel.applyTypography(.textSm(weight: .regular))
        }

        let attachment = item.attachments.first { $0.isImage }
        attachmentImageView.isHidden = attachment == nil
        attachmentHeightConstraint?.update(offset: attachment == nil ? 0 : Metric.attachmentHeight)
        pendingAttachmentPath = attachment?.path

        if let attachment {
            loadAttachment(attachment.path) { [weak self] data in
                guard let self,
                      self.pendingAttachmentPath == attachment.path,
                      let data else { return }
                self.attachmentImageView.image = UIImage(data: data)
            }
        }

        timeLabel.isHidden = item.timeText.isEmpty
        timeLabel.textAlignment = .natural
        timeLabel.text = item.timeText
        timeLabel.applyTypography(.textXs(weight: .regular))

        layout(isOutgoing: item.isOutgoing, maxWidth: maxWidth)
    }
}

private extension ChatMessageCell {
    func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(bubbleView)
        contentView.addSubview(timeLabel)

        bubbleView.addSubview(attachmentImageView)
        bubbleView.addSubview(messageLabel)

        attachmentImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(4)
            attachmentHeightConstraint = make.height.equalTo(0).constraint
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(attachmentImageView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(8)
        }

        timeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        timeLabel.setContentHuggingPriority(.required, for: .horizontal)
    }

    func layout(isOutgoing: Bool, maxWidth: CGFloat) {
        let bubbleMaxWidth = maxWidth * Metric.maxBubbleWidthRatio

        bubbleView.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Metric.verticalInset)
            make.width.lessThanOrEqualTo(bubbleMaxWidth)

            if isOutgoing {
                make.trailing.equalToSuperview().inset(Metric.horizontalInset)
            } else {
                make.leading.equalToSuperview().inset(Metric.horizontalInset)
            }
        }

        timeLabel.snp.remakeConstraints { make in
            make.bottom.equalTo(bubbleView.snp.bottom)

            if isOutgoing {
                make.trailing.equalTo(bubbleView.snp.leading).offset(-Metric.timeSpacing)
                make.leading.greaterThanOrEqualToSuperview().inset(Metric.horizontalInset)
            } else {
                make.leading.equalTo(bubbleView.snp.trailing).offset(Metric.timeSpacing)
                make.trailing.lessThanOrEqualToSuperview().inset(Metric.horizontalInset)
            }
        }
    }
}

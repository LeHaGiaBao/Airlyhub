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
///
/// Incoming and outgoing rows share this cell and differ only in which edge they hang
/// off, so the side-dependent constraints are remade on every `configure` rather than
/// being split into two cell classes.
final class ChatMessageCell: UITableViewCell {
    static let reuseIdentifier = "ChatMessageCell"

    private enum Metric {
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 4
        /// Keeps a long message from filling the row edge to edge, which is what makes
        /// the left/right split readable at a glance.
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

    /// Nil-ed and rebuilt per configuration; kept so the previous side's constraints can
    /// be dropped before the new ones go in.
    private var attachmentHeightConstraint: Constraint?

    /// What this cell is currently waiting on. Compared when the fetch returns, because
    /// the cell may have been recycled onto a different message by then — without this
    /// a slow load lands its photo in whichever row happens to be on screen.
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
        // The image arrives asynchronously; without this a recycled cell shows the
        // previous row's photo until the new fetch lands.
        attachmentImageView.image = nil
        pendingAttachmentPath = nil
    }

    func configure(with item: ChatBubbleItem, maxWidth: CGFloat) {
        bubbleView.backgroundColor = item.isOutgoing
            ? AppColor.PrimaryColors.Primary.color700
            : AppColor.PrimaryColors.Primary.color500

        // A message still on its way to the server reads as slightly faded, which is
        // enough of a signal without adding a spinner to every bubble.
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
            ChatAttachmentService.shared.load(path: attachment.path) { [weak self] data in
                guard let self,
                      // Still the same message? A recycled cell must not adopt this photo.
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

// MARK: - UI
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

        // The label wins over the time stamp when space is tight, so a long message
        // wraps instead of squeezing the clock into an ellipsis.
        timeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        timeLabel.setContentHuggingPriority(.required, for: .horizontal)
    }

    /// Remakes only the constraints that depend on which side the bubble sits on.
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

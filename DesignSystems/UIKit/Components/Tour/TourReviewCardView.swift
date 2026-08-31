//
//  TourReviewCardView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

/// One entry under "Customer reviews": avatar, name and date on top, the star row,
/// then the comment.
final class TourReviewCardView: UIView {
    private enum Layout {
        static let avatarSize: CGFloat = 40
        static let avatarCornerRadius: CGFloat = 8
        static let headerSpacing: CGFloat = 12
        static let sectionSpacing: CGFloat = 8
    }

    private static let placeholderAvatar = UIImage(systemName: "person.crop.circle")

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = AppColor.PrimaryColors.Gray.color200
        imageView.tintColor = AppColor.PrimaryColors.Gray.color400
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textSm(weight: .semibold))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textXs(weight: .regular))
        label.textColor = AppColor.PrimaryColors.Gray.color500
        return label
    }()

    private lazy var nameStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, dateLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 2
        return stack
    }()

    private lazy var headerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [avatarImageView, nameStack])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = Layout.headerSpacing
        return stack
    }()

    private let ratingView = StarRatingView()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textSm(weight: .regular))
        label.textColor = AppColor.PrimaryColors.Gray.color700
        label.numberOfLines = 0
        return label
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headerStack, ratingView, commentLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = Layout.sectionSpacing
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with review: TourReviewModel) {
        avatarImageView.setCachedImage(from: review.authorAvatarURL, placeholder: Self.placeholderAvatar)
        nameLabel.setText(review.authorName)
        dateLabel.setText(Self.dateFormatter.string(from: review.date))
        ratingView.configure(rating: Double(review.rating))
        commentLabel.setText(review.comment)
    }

    private func setupUI() {
        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(Layout.avatarSize)
        }
        avatarImageView.layer.cornerRadius = Layout.avatarCornerRadius
    }
}

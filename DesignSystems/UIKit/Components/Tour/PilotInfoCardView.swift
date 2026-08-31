//
//  PilotInfoCardView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

/// The "Pilot information" card: avatar, name and rating up top, then two stat
/// tiles and a full-width license row underneath.
///
/// The card tints itself `color50` and the tiles inside it darken a step to
/// `color100` — the inverse of the rest of the screen, where white cards carry grey
/// rows. It is the one block nested two levels deep, and stepping the outer level
/// lighter is what keeps the three tiles readable as separate facts rather than as
/// one paragraph, without introducing a third, plain-white surface into a card
/// that is otherwise built from grey steps alone.
final class PilotInfoCardView: UIView {
    private enum Layout {
        static let avatarSize: CGFloat = 64
        static let avatarCornerRadius: CGFloat = 12
        static let headerSpacing: CGFloat = 16
        static let sectionSpacing: CGFloat = 20
        static let statSpacing: CGFloat = 12
        static let cornerRadius: CGFloat = 12
        static let padding: CGFloat = 20
    }

    private static let placeholderAvatar = UIImage(systemName: "person.crop.circle")

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
        label.applyTypography(.textMd(weight: .semibold))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        return label
    }()

    private let ratingView = StarRatingView()

    private lazy var nameStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, ratingView])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 4
        return stack
    }()

    private lazy var headerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [avatarImageView, nameStack])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = Layout.headerSpacing
        return stack
    }()

    private let airplaneTile = StatTileView()
    private let hoursFlownTile = StatTileView()

    private lazy var statsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [airplaneTile, hoursFlownTile])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = Layout.statSpacing
        return stack
    }()

    private let licenseTile = StatTileView()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headerStack, statsStack, licenseTile])
        stack.axis = .vertical
        stack.alignment = .fill
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

    func configure(with pilot: PilotModel) {
        avatarImageView.setCachedImage(from: pilot.avatarURL, placeholder: Self.placeholderAvatar)
        nameLabel.setText(pilot.name)
        ratingView.configure(rating: pilot.rating)

        airplaneTile.configure(
            caption: NSLocalizedString("tour_detail_airplane", comment: ""),
            value: pilot.airplane
        )
        hoursFlownTile.configure(
            caption: NSLocalizedString("tour_detail_hours_flown", comment: ""),
            value: String(format: NSLocalizedString("tour_detail_hours_value", comment: ""), pilot.hoursFlown)
        )
        licenseTile.configure(
            caption: NSLocalizedString("tour_detail_license", comment: ""),
            value: pilot.license
        )
    }

    private func setupUI() {
        backgroundColor = AppColor.PrimaryColors.Gray.color50
        layer.cornerRadius = Layout.cornerRadius
        clipsToBounds = true

        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Layout.padding)
        }

        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(Layout.avatarSize)
        }
        avatarImageView.layer.cornerRadius = Layout.avatarCornerRadius
    }
}

// MARK: - StatTileView
/// One caption-over-value pair on a light rounded background — "Airplane" over
/// "Cessna 172". `licenseTile` above spans the full width of the same view.
private final class StatTileView: UIView {
    private enum Layout {
        static let cornerRadius: CGFloat = 10
        static let padding: CGFloat = 16
        static let spacing: CGFloat = 6
    }

    private let captionLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textXs(weight: .regular))
        label.textColor = AppColor.PrimaryColors.Gray.color400
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textSm(weight: .semibold))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        label.numberOfLines = 0
        return label
    }()

    init() {
        super.init(frame: .zero)

        backgroundColor = AppColor.PrimaryColors.Gray.color100
        layer.cornerRadius = Layout.cornerRadius
        clipsToBounds = true

        let stack = UIStackView(arrangedSubviews: [captionLabel, valueLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = Layout.spacing

        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Layout.padding)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(caption: String, value: String) {
        captionLabel.setText(caption)
        valueLabel.setText(value)
    }
}

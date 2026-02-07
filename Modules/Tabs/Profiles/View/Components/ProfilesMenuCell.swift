//
//  ProfilesMenuCell.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 06/02/2026.
//

import Foundation
import UIKit

final class ProfilesMenuCell: UITableViewCell {
    static let identifier = "ProfilesMenuCell"
    
    private let normalBackgroundColor = AppColor.PrimaryColors.Gray.color100
    private let pressedBackgroundColor = AppColor.PrimaryColors.Gray.color200

    private let containerView = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let badgeLabel = UILabel()
    private var containerTopConstraint: NSLayoutConstraint?
    private var containerBottomConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupBadge()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        containerView.backgroundColor = normalBackgroundColor
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true

        contentView.addSubview(containerView)

        iconView.contentMode = .scaleAspectFit
        iconView.setContentHuggingPriority(.required, for: .horizontal)

        let stack = UIStackView(arrangedSubviews: [iconView, titleLabel])
        stack.spacing = 12
        stack.alignment = .center

        containerView.addSubview(stack)
        containerView.addSubview(badgeLabel)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false

        containerTopConstraint = containerView.topAnchor.constraint(
            equalTo: contentView.topAnchor
        )
        containerBottomConstraint = containerView.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor
        )

        NSLayoutConstraint.activate([
            containerTopConstraint!,
            containerBottomConstraint!,
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),

            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),

            stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: badgeLabel.leadingAnchor, constant: -16),

            badgeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            badgeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 24),
            badgeLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    private func setupBadge() {
        badgeLabel.backgroundColor = AppColor.PrimaryColors.Error.color500
        badgeLabel.textColor = AppColor.PrimaryColors.Gray.color25
        badgeLabel.applyTypography(.textXs(weight: .semibold))
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 8
        badgeLabel.clipsToBounds = true
        badgeLabel.isHidden = true
    }

    func configure(
        _ item: ProfilesMenuItem,
        position: ProfilesMenuCellPosition
    ) {
        titleLabel.text = item.title
        iconView.image = item.iconName

        if case let .cards(badge) = item.type, let badge {
            badgeLabel.text = "\(badge)"
            badgeLabel.isHidden = false
        } else {
            badgeLabel.isHidden = true
        }

        applyCorner(position)
    }
    
    private func applyCorner(_ position: ProfilesMenuCellPosition) {

        switch position {
        case .single:
            containerTopConstraint?.constant = 16
            containerBottomConstraint?.constant = 0
            containerView.layer.cornerRadius = 12
            containerView.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
            ]

        case .top:
            containerTopConstraint?.constant = 16
            containerBottomConstraint?.constant = 0
            containerView.layer.cornerRadius = 12
            containerView.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner
            ]

        case .middle:
            containerTopConstraint?.constant = 0
            containerBottomConstraint?.constant = 0
            containerView.layer.cornerRadius = 0
            containerView.layer.maskedCorners = []

        case .bottom:
            containerTopConstraint?.constant = 0
            containerBottomConstraint?.constant = 0
            containerView.layer.cornerRadius = 12
            containerView.layer.maskedCorners = [
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
            ]
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        updatePressedState(isPressed: highlighted, animated: animated)
    }

    private func updatePressedState(isPressed: Bool, animated: Bool) {
        let targetColor = isPressed ? pressedBackgroundColor : normalBackgroundColor
        let targetTransform: CGAffineTransform = isPressed
            ? CGAffineTransform(scaleX: 0.98, y: 0.98)
            : .identity
        let changes = {
            self.containerView.backgroundColor = targetColor
            self.containerView.transform = targetTransform
        }
        guard animated else {
            changes()
            return
        }
        UIView.animate(withDuration: 0.12, animations: changes)
    }
}

//
//  AddNewCardCell.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

/// The always-present "Add new card" row. It doubles as the empty state — when a user
/// has no cards this is the only row on screen, which is exactly the design's empty layout.
final class AddNewCardCell: UITableViewCell {
    static let identifier = "AddNewCardCell"

    private let normalBackgroundColor = AppColor.PrimaryColors.Gray.color100
    private let pressedBackgroundColor = AppColor.PrimaryColors.Gray.color200

    private let containerView = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        let changes = { self.containerView.backgroundColor = highlighted
            ? self.pressedBackgroundColor
            : self.normalBackgroundColor }

        guard animated else {
            changes()
            return
        }
        UIView.animate(withDuration: 0.12, animations: changes)
    }
}

private extension AddNewCardCell {
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        containerView.backgroundColor = normalBackgroundColor
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true

        iconView.image = AssetsIcon.cards
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = AppColor.PrimaryColors.Gray.color600

        titleLabel.text = NSLocalizedString("add_new_card", comment: "")
        titleLabel.applyTypography(.textSm(weight: .regular))
        titleLabel.textColor = AppColor.PrimaryColors.Gray.color800

        contentView.addSubview(containerView)
        containerView.addSubview(iconView)
        containerView.addSubview(titleLabel)

        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(56)
        }

        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
    }
}

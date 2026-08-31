//
//  SmallTicket.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class SmallTicket: UIView {
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textMd(weight: .medium))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        return label
    }()

    private let priceBadge = PriceBadgeView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textXs(weight: .regular))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        label.numberOfLines = 0
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textXs(weight: .regular))
        label.textColor = AppColor.PrimaryColors.Gray.color500
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = AppColor.BaseColor.backgroundColor?.withAlphaComponent(0.5)
        layer.cornerRadius = 12
        clipsToBounds = true

        addSubview(numberLabel)
        addSubview(priceBadge)
        addSubview(titleLabel)
        addSubview(subtitleLabel)

        numberLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        numberLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        numberLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
        }

        priceBadge.snp.makeConstraints { make in
            make.centerY.equalTo(numberLabel)
            make.right.equalToSuperview().inset(16)
            make.left.greaterThanOrEqualTo(numberLabel.snp.right).offset(12)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    func configure(with ticket: SmallTicketModel) {
        numberLabel.text = ticket.id
        priceBadge.text = ticket.priceText
        titleLabel.text = ticket.title
        subtitleLabel.text = ticket.subtitle
    }
}

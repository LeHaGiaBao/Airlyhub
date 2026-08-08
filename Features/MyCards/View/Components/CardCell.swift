//
//  CardCell.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

final class CardCell: UITableViewCell {
    static let identifier = "CardCell"

    private let logoContainer = UIView()
    private let logoImageView = UIImageView()
    private let logoFallbackLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let checkImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ item: CardItem) {
        titleLabel.text = item.maskedNumber

        if item.isExpired {
            subtitleLabel.text = NSLocalizedString("card_expired", comment: "")
            subtitleLabel.textColor = AppColor.PrimaryColors.Error.color500
        } else {
            subtitleLabel.text = item.expiryDisplay
            subtitleLabel.textColor = AppColor.PrimaryColors.Gray.color500
        }

        // Assets land as `card_visa`, `card_mastercard`, … Until then the short brand
        // name stands in, so the row is readable with no artwork present.
        if let logo = item.brand.logo {
            logoImageView.image = logo
            logoImageView.isHidden = false
            logoFallbackLabel.isHidden = true
        } else {
            logoImageView.isHidden = true
            logoFallbackLabel.isHidden = false
            logoFallbackLabel.text = item.brand.shortName
        }

        checkImageView.isHidden = !item.isDefault

        // Expired cards read as inactive but stay visible so they can still be deleted.
        let alpha: CGFloat = item.isExpired ? 0.45 : 1.0
        logoContainer.alpha = alpha
        titleLabel.alpha = alpha
    }
}

// MARK: - UI
private extension CardCell {
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(64)
        }

        logoContainer.backgroundColor = AppColor.PrimaryColors.Gray.color50
        logoContainer.layer.cornerRadius = 6
        logoContainer.layer.borderWidth = 1
        logoContainer.layer.borderColor = (AppColor.PrimaryColors.Gray.color200 ?? .separator).cgColor
        logoContainer.clipsToBounds = true

        logoImageView.contentMode = .scaleAspectFit

        logoFallbackLabel.applyTypography(.textXs(weight: .bold))
        logoFallbackLabel.textColor = AppColor.PrimaryColors.Gray.color600
        logoFallbackLabel.textAlignment = .center
        logoFallbackLabel.adjustsFontSizeToFitWidth = true
        logoFallbackLabel.minimumScaleFactor = 0.6

        titleLabel.applyTypography(.textSm(weight: .regular))
        titleLabel.textColor = AppColor.PrimaryColors.Gray.color800

        subtitleLabel.applyTypography(.textXs(weight: .regular))
        subtitleLabel.textColor = AppColor.PrimaryColors.Gray.color500

        checkImageView.image = UIImage(systemName: "checkmark.circle.fill")
        checkImageView.tintColor = AppColor.PrimaryColors.Primary.color500
        checkImageView.contentMode = .scaleAspectFit
        checkImageView.isHidden = true

        contentView.addSubview(logoContainer)
        logoContainer.addSubview(logoImageView)
        logoContainer.addSubview(logoFallbackLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(checkImageView)

        logoContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(30)
        }

        logoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }

        logoFallbackLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(logoContainer.snp.trailing).offset(12)
            make.top.equalToSuperview().offset(12)
            make.trailing.lessThanOrEqualTo(checkImageView.snp.leading).offset(-12)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.bottom.equalToSuperview().offset(-12)
            make.trailing.lessThanOrEqualTo(checkImageView.snp.leading).offset(-12)
        }

        checkImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(22)
        }
    }
}

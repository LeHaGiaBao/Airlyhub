//
//  SavedCardRowView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

/// One selectable saved card on the checkout form.
final class SavedCardRowView: UIView {
    private enum Layout {
        static let height: CGFloat = 64
        static let cornerRadius: CGFloat = 8
        static let horizontalPadding: CGFloat = 12
        static let logoSpacing: CGFloat = 12
        static let checkSize: CGFloat = 22
    }

    var onTap: ((String) -> Void)?

    private(set) var cardID: String?

    private let logoContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.layer.borderColor = (AppColor.PrimaryColors.Gray.color200 ?? .separator).cgColor
        view.clipsToBounds = true
        return view
    }()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let logoFallbackLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textXs(weight: .bold))
        label.textColor = AppColor.PrimaryColors.Gray.color600
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textSm(weight: .regular))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textXs(weight: .regular))
        return label
    }()

    private let checkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        imageView.tintColor = AppColor.PrimaryColors.Primary.color500
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with card: CardModel, isSelected: Bool) {
        cardID = card.id
        titleLabel.text = CardFormatter.masked(last4: card.last4, brand: card.brand)

        if card.isExpired {
            subtitleLabel.text = NSLocalizedString("card_expired", comment: "")
            subtitleLabel.textColor = AppColor.PrimaryColors.Error.color500
        } else {
            subtitleLabel.text = card.expiryDisplay
            subtitleLabel.textColor = AppColor.PrimaryColors.Gray.color500
        }

        if let logo = card.brand.logo {
            logoImageView.image = logo
            logoImageView.isHidden = false
            logoFallbackLabel.isHidden = true
            logoContainer.backgroundColor = .clear
            logoContainer.layer.borderWidth = 0
        } else {
            logoImageView.image = nil
            logoImageView.isHidden = true
            logoFallbackLabel.isHidden = false
            logoFallbackLabel.text = card.brand.shortName
            logoContainer.backgroundColor = AppColor.PrimaryColors.Gray.color50
            logoContainer.layer.borderWidth = 1
        }

        checkImageView.isHidden = !isSelected
        backgroundColor = isSelected
            ? AppColor.PrimaryColors.Primary.color50
            : AppColor.PrimaryColors.Gray.color25
        layer.borderWidth = isSelected ? 1 : 0
        layer.borderColor = AppColor.PrimaryColors.Primary.color500?.cgColor
    }

    private func setupUI() {
        layer.cornerRadius = Layout.cornerRadius
        backgroundColor = AppColor.PrimaryColors.Gray.color25

        addSubview(logoContainer)
        logoContainer.addSubview(logoImageView)
        logoContainer.addSubview(logoFallbackLabel)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(checkImageView)

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        snp.makeConstraints { make in
            make.height.equalTo(Layout.height)
        }

        logoContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Layout.horizontalPadding)
            make.centerY.equalToSuperview()
            make.width.equalTo(CardBrand.logoSize.width)
            make.height.equalTo(CardBrand.logoSize.height)
        }

        logoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        logoFallbackLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }

        checkImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Layout.horizontalPadding)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(Layout.checkSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(logoContainer.snp.trailing).offset(Layout.logoSpacing)
            make.trailing.lessThanOrEqualTo(checkImageView.snp.leading).offset(-Layout.logoSpacing)
            make.bottom.equalTo(snp.centerY).offset(-1)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.lessThanOrEqualTo(titleLabel)
            make.top.equalTo(snp.centerY).offset(1)
        }
    }

    @objc private func handleTap() {
        guard let cardID else { return }
        FeedbackGenerator.onFeedbackGenerator(.soft)
        onTap?(cardID)
    }
}

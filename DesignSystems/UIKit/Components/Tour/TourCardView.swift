//
//  TourCardView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

/// One result card: photo with a favourite toggle and attribute chips, the title
/// underneath, and — only when the model carries a price — a per-passenger price row.
///
/// This single view backs both search screens. Explore passes a model with
/// `priceText == nil` and the price row collapses; Flights passes one with a price
/// and it appears. See `TourCardModel` for why the difference lives in the data.
final class TourCardView: UIView {
    private enum Layout {
        static let imageCornerRadius: CGFloat = 12
        /// Matches the 16:10 crop in the design.
        static let imageAspectRatio: CGFloat = 10.0 / 16.0
        static let badgeInset: CGFloat = 8
        static let favoriteSize: CGFloat = 24
        static let favoriteInset: CGFloat = 8
        static let titleSpacing: CGFloat = 12
        static let priceSpacing: CGFloat = 12
    }

    /// Sized down to sit centred inside the 24pt disc with a little breathing room.
    private static let favoriteConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)
    private static let favoriteOn = UIImage(systemName: "heart.fill", withConfiguration: favoriteConfig)
    private static let favoriteOff = UIImage(systemName: "heart", withConfiguration: favoriteConfig)
    private static let placeholder = UIImage(systemName: "airplane")

    /// Carries the model's id so a list can act without holding an index that a
    /// reload may have invalidated.
    var onToggleFavorite: ((String) -> Void)?

    /// Id of the model currently rendered — lets a container resolve a tap without
    /// searching for the view it came from.
    private(set) var itemID: String?

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Layout.imageCornerRadius
        imageView.backgroundColor = AppColor.PrimaryColors.Gray.color200
        imageView.tintColor = AppColor.PrimaryColors.Gray.color400
        return imageView
    }()

    /// Round scrim disc floating on the photo, heart centred inside it.
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.18)
        button.layer.cornerRadius = Layout.favoriteSize / 2
        button.contentEdgeInsets = .zero
        button.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        return button
    }()

    private let badgeStrip = TourBadgeStripView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textMd(weight: .semibold))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        label.numberOfLines = 2
        return label
    }()

    private let priceCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("tour_price_per_passenger", comment: "")
        label.applyTypography(.textXs(weight: .regular))
        label.textColor = AppColor.PrimaryColors.Gray.color500
        return label
    }()

    private let priceBadge = PriceBadgeView()

    private lazy var priceRow: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [priceCaptionLabel, priceBadge])
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()

    /// Title and price live in a stack so that hiding the price row actually
    /// collapses it. Pinned with constraints instead, an `isHidden` row would keep
    /// its height and leave a gap under every Explore card.
    private lazy var infoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, priceRow])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = Layout.priceSpacing
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: TourCardModel) {
        itemID = item.id
        // `setText`, not `.text`: a plain assignment drops the textMd/semibold
        // styling `applyTypography` baked in at init, leaving the title in the
        // system font.
        titleLabel.setText(item.title)
        badgeStrip.configure(ratingText: item.ratingText, badges: item.badges)
        imageView.setCachedImage(from: item.imageURL, placeholder: Self.placeholder)
        setFavorite(item.isFavorite)

        // Hiding the row rather than building a second card is the whole reuse
        // mechanism — see the type comment.
        priceRow.isHidden = item.priceText == nil
        priceBadge.text = item.priceText
    }

    /// Lets a list flip the heart optimistically without rebuilding the card.
    func setFavorite(_ isFavorite: Bool) {
        favoriteButton.setImage(isFavorite ? Self.favoriteOn : Self.favoriteOff, for: .normal)
    }

    private func setupUI() {
        addSubview(imageView)
        imageView.addSubview(favoriteButton)
        imageView.addSubview(badgeStrip)
        addSubview(infoStack)

        imageView.isUserInteractionEnabled = true

        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(imageView.snp.width).multipliedBy(Layout.imageAspectRatio)
        }

        favoriteButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(Layout.favoriteInset)
            make.width.height.equalTo(Layout.favoriteSize)
        }

        badgeStrip.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview().inset(Layout.badgeInset)
            make.right.lessThanOrEqualToSuperview().inset(Layout.badgeInset)
        }

        infoStack.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Layout.titleSpacing)
            make.left.right.bottom.equalToSuperview()
        }
    }

    @objc private func favoriteTapped() {
        guard let itemID else { return }
        onToggleFavorite?(itemID)
    }
}

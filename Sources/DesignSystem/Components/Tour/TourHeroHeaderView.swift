//
//  TourHeroHeaderView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

/// The photo at the top of the tour detail screen: full-bleed under the status bar,
/// a back button and a favourite toggle floating over it, and the same badge strip
/// a search result's card shows.
final class TourHeroHeaderView: UIView {
    private enum Layout {
        static let controlSize: CGFloat = 24
        static let controlInset: CGFloat = 16
        static let badgeInset: CGFloat = 12
    }

    private static let favoriteConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)
    private static let favoriteOn = UIImage(systemName: "heart.fill", withConfiguration: favoriteConfig)
    private static let favoriteOff = UIImage(systemName: "heart", withConfiguration: favoriteConfig)
    private static let placeholder = UIImage(systemName: "airplane")

    var onBack: (() -> Void)?
    var onToggleFavorite: (() -> Void)?

    var bottomCornerRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    private let cornerMask = CAShapeLayer()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = AppColor.PrimaryColors.Gray.color200
        imageView.tintColor = AppColor.PrimaryColors.Gray.color400
        return imageView
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(AssetsIcon.arrowLeft, for: .normal)
        return button
    }()

    private lazy var favoriteButton = Self.makeFavoriteControl(image: Self.favoriteOff)

    private let badgeStrip = TourBadgeStripView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func stretchImage(alongside scrollView: UIScrollView) {
        imageView.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(scrollView.frameLayoutGuide.snp.top)
        }
    }

    func configure(imageURL: String?, ratingText: String?, badges: [String], isFavorite: Bool) {
        imageView.setCachedImage(from: imageURL, placeholder: Self.placeholder)
        badgeStrip.configure(ratingText: ratingText, badges: badges)
        setFavorite(isFavorite)
    }

    func setFavorite(_ isFavorite: Bool) {
        favoriteButton.setImage(isFavorite ? Self.favoriteOn : Self.favoriteOff, for: .normal)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        cornerMask.frame = bounds
        let top = min(0, imageView.frame.minY)
        let radii = CGSize(width: bottomCornerRadius, height: bottomCornerRadius)
        cornerMask.path = UIBezierPath(
            roundedRect: CGRect(x: 0, y: top, width: bounds.width, height: bounds.height - top),
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: radii
        ).cgPath
    }

    private func setupUI() {
        clipsToBounds = false
        layer.mask = cornerMask

        addSubview(imageView)
        addSubview(backButton)
        addSubview(favoriteButton)
        addSubview(badgeStrip)

        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)

        imageView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.lessThanOrEqualToSuperview()
            make.top.equalToSuperview().priority(.high)
        }

        backButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(Layout.controlInset)
            make.left.equalToSuperview().offset(Layout.controlInset)
            make.width.height.equalTo(Layout.controlSize)
        }

        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.right.equalToSuperview().inset(Layout.controlInset)
            make.width.height.equalTo(Layout.controlSize)
        }

        badgeStrip.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Layout.badgeInset)
            make.right.lessThanOrEqualToSuperview().inset(Layout.badgeInset)
            make.bottom.equalToSuperview().inset(Layout.badgeInset)
        }
    }

    private static func makeFavoriteControl(image: UIImage?) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.18)
        button.layer.cornerRadius = Layout.controlSize / 2
        button.contentEdgeInsets = .zero
        return button
    }

    @objc private func backTapped() {
        onBack?()
    }

    @objc private func favoriteTapped() {
        onToggleFavorite?()
    }
}

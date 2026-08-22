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
///
/// The back/favourite pair use the same translucent circle `TourCardView` uses for
/// its favourite button, so a card's photo and its detail screen's photo read as
/// one continuous surface rather than two different treatments of "controls over
/// an image".
final class TourHeroHeaderView: UIView {
    private enum Layout {
        static let controlSize: CGFloat = 36
        static let controlInset: CGFloat = 16
        static let badgeInset: CGFloat = 12
    }

    private static let favoriteOn = UIImage(systemName: "heart.fill")
    private static let favoriteOff = UIImage(systemName: "heart")
    private static let placeholder = UIImage(systemName: "airplane")

    var onBack: (() -> Void)?
    var onToggleFavorite: (() -> Void)?

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = AppColor.PrimaryColors.Gray.color200
        imageView.tintColor = AppColor.PrimaryColors.Gray.color400
        return imageView
    }()

    private lazy var backButton = Self.makeControl(image: UIImage(systemName: "chevron.left"))
    private lazy var favoriteButton = Self.makeControl(image: Self.favoriteOff)

    private let badgeStrip = TourBadgeStripView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(imageURL: String?, ratingText: String?, badges: [String], isFavorite: Bool) {
        imageView.setCachedImage(from: imageURL, placeholder: Self.placeholder)
        badgeStrip.configure(ratingText: ratingText, badges: badges)
        setFavorite(isFavorite)
    }

    /// Lets the screen flip the heart optimistically without a full `configure`.
    func setFavorite(_ isFavorite: Bool) {
        favoriteButton.setImage(isFavorite ? Self.favoriteOn : Self.favoriteOff, for: .normal)
    }

    private func setupUI() {
        clipsToBounds = true

        addSubview(imageView)
        addSubview(backButton)
        addSubview(favoriteButton)
        addSubview(badgeStrip)

        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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

    private static func makeControl(image: UIImage?) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.18)
        button.layer.cornerRadius = Layout.controlSize / 2
        return button
    }

    @objc private func backTapped() {
        onBack?()
    }

    @objc private func favoriteTapped() {
        onToggleFavorite?()
    }
}

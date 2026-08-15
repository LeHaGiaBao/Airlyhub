//
//  TourCarouselCell.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

/// Compact tile in the "Popular" rail: artwork with the title underneath.
///
/// Deliberately not a shrunken `TourCardView`. The rail is a browsing shortcut, so
/// it drops the chips, the price and the favourite button — squeezing those into
/// 104pt would make all of them unreadable rather than making the tile informative.
final class TourCarouselCell: UICollectionViewCell {
    static let reuseID = "TourCarouselCell"
    static let itemSize = CGSize(width: 104, height: 132)

    private enum Layout {
        static let cornerRadius: CGFloat = 12
        static let imageHeight: CGFloat = 96
        static let titleSpacing: CGFloat = 8
    }

    private static let placeholder = UIImage(systemName: "airplane")

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Layout.cornerRadius
        imageView.backgroundColor = AppColor.PrimaryColors.Gray.color200
        imageView.tintColor = AppColor.PrimaryColors.Gray.color400
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textXs(weight: .regular))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        label.numberOfLines = 2
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // Clearing the source detaches any in-flight request from this cell, so a
        // late response cannot paint the previous tour's artwork over the new one.
        imageView.setCachedImage(from: nil, placeholder: Self.placeholder)
        titleLabel.text = nil
    }

    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)

        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(Layout.imageHeight)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Layout.titleSpacing)
            make.left.right.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }

    func configure(with item: TourCardModel) {
        titleLabel.text = item.title
        imageView.setCachedImage(from: item.imageURL, placeholder: Self.placeholder)
    }
}

//
//  HelpfulInformationCell.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class HelpfulInformationCell: UICollectionViewCell {
    static let reuseID = "HelpfulInformationCell"
    static let itemSize = CGSize(width: 104, height: 132)

    private static let titleStyle: TypographyStyle = .textXs(weight: .semibold)

    private enum Layout {
        static let cornerRadius: CGFloat = 12
        static let borderWidth: CGFloat = 2
        static let imageInset: CGFloat = 5
        static let textInset: CGFloat = 8

        static var imageCornerRadius: CGFloat { cornerRadius - imageInset }
    }

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Layout.imageCornerRadius
        imageView.backgroundColor = AppColor.PrimaryColors.Gray.color300
        return imageView
    }()

    private let scrimLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.black.withAlphaComponent(0.55).cgColor,
            UIColor.black.withAlphaComponent(0).cgColor
        ]
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        return layer
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 3
        label.applyTypography(titleStyle)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        scrimLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: imageView.bounds.width,
            height: imageView.bounds.height * 0.6
        )
    }

    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = Layout.cornerRadius
        contentView.clipsToBounds = true
        contentView.layer.borderWidth = Layout.borderWidth
        contentView.layer.borderColor = AppColor.PrimaryColors.Primary.color500?.cgColor

        contentView.addSubview(imageView)
        imageView.layer.addSublayer(scrimLayer)
        contentView.addSubview(titleLabel)

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Layout.imageInset)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalTo(imageView).inset(Layout.textInset)
        }
    }

    func configure(with item: HelpfulInformationItem) {
        titleLabel.text = item.title
        titleLabel.applyTypography(Self.titleStyle)
        imageView.image = item.imageName.flatMap { UIImage(named: $0) }
    }
}

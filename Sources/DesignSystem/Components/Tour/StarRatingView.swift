//
//  StarRatingView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

/// Five stars plus the number, in the pilot card and under each review.
final class StarRatingView: UIView {
    private enum Layout {
        static let starSize: CGFloat = 14
        static let starSpacing: CGFloat = 2
        static let valueSpacing: CGFloat = 6
        static let starCount = 5
    }

    private static let filledStar = UIImage(systemName: "star.fill")
    private static let emptyStar = UIImage(systemName: "star")

    private let starsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Layout.starSpacing
        return stack
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textSm(weight: .semibold))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        return label
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [starsStack, valueLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = Layout.valueSpacing
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(rating: Double) {
        starsStack.arrangedSubviews.forEach {
            starsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let filledCount = Int(rating.rounded())
        for index in 0..<Layout.starCount {
            let imageView = UIImageView(image: index < filledCount ? Self.filledStar : Self.emptyStar)
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = AppColor.PrimaryColors.Warning.color500
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(Layout.starSize)
            }
            starsStack.addArrangedSubview(imageView)
        }

        valueLabel.setText("\(Int(rating.rounded()))")
    }

    private func setupUI() {
        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

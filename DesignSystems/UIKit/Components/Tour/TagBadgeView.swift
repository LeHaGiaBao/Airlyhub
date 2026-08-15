//
//  TagBadgeView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

/// Neutral pill used for the attribute chips on a tour card — rating, airfield, seats.
///
/// Separate from `PriceBadgeView` rather than a variant of it: that one is a solid
/// primary-blue price tag, this one is a translucent light chip that sits on top of
/// photography. Different roles, different tokens, and merging them would mean a
/// style flag on both call sites.
final class TagBadgeView: UIView {
    private enum Layout {
        static let height: CGFloat = 22
        static let horizontalInset: CGFloat = 8
        static let iconSize: CGFloat = 11
        static let iconSpacing: CGFloat = 3
    }

    var text: String? {
        didSet { titleLabel.text = text }
    }

    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = AppColor.PrimaryColors.Gray.color800
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textXs(weight: .medium))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        // The strip lays chips out left to right; the last one gives way first
        // rather than pushing the row past the card edge.
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconView, titleLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = Layout.iconSpacing
        return stack
    }()

    init(text: String? = nil, icon: UIImage? = nil) {
        super.init(frame: .zero)
        self.text = text
        titleLabel.text = text
        setupUI()
        setIcon(icon)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setIcon(nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

    /// Passing nil collapses the glyph, so a chip with no icon has no dead space.
    func setIcon(_ icon: UIImage?) {
        iconView.image = icon
        iconView.isHidden = icon == nil
    }

    private func setupUI() {
        // Translucent rather than opaque white: the chips sit on photography and a
        // solid fill reads as a hole punched in the image.
        backgroundColor = UIColor.white.withAlphaComponent(0.92)
        clipsToBounds = true

        addSubview(contentStack)

        contentStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Layout.horizontalInset)
            make.centerY.equalToSuperview()
        }

        iconView.snp.makeConstraints { make in
            make.width.height.equalTo(Layout.iconSize)
        }

        snp.makeConstraints { make in
            make.height.equalTo(Layout.height)
        }
    }
}

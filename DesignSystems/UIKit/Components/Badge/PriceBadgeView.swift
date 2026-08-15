//
//  PriceBadgeView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 17/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class PriceBadgeView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textXs(weight: .medium))
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    var text: String? {
        didSet {
            titleLabel.text = text
        }
    }

    init(text: String? = nil) {
        super.init(frame: .zero)
        self.text = text
        titleLabel.text = text
        setupUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

    private func setupUI() {
        backgroundColor = AppColor.PrimaryColors.Primary.color500
        clipsToBounds = true

        // The priorities that matter are the label's, not this view's: a plain
        // `UIView` has no intrinsic content size, so hugging set on `self` is a
        // no-op and a stack view with `.fill` finds nothing here to resist it —
        // the pill then swallows all the slack in the row and stretches to the
        // card's width. Pinned to the label at required priority, the pill is as
        // wide as its price and whatever sits beside it absorbs the space instead.
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(2)
            make.left.right.equalToSuperview().inset(8)
        }
    }
}

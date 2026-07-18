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
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(2)
            make.left.right.equalToSuperview().inset(8)
        }
    }
}

//
//  SearchSummaryHeaderView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

/// Back arrow, a pill recapping what was searched for, and a filter button.
final class SearchSummaryHeaderView: UIView {
    private enum Layout {
        static let height: CGFloat = 48
        static let iconSize: CGFloat = 24
        static let spacing: CGFloat = 16
        static let cornerRadius: CGFloat = 12
        static let borderWidth: CGFloat = 1
        static let pillLeadingInset: CGFloat = 16
        static let pillTrailingInset: CGFloat = 12
        static let pillContentSpacing: CGFloat = 8
    }

    var onBack: (() -> Void)?
    var onFilter: (() -> Void)? {
        didSet { filterButton.isHidden = onFilter == nil }
    }

    var summary: String? {
        get { summaryLabel.text }
        set { summaryLabel.text = newValue }
    }

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(AssetsIcon.arrowLeft, for: .normal)
        button.tintColor = AppColor.PrimaryColors.Gray.color800
        return button
    }()

    private let pillView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Layout.cornerRadius
        view.layer.borderWidth = Layout.borderWidth
        view.layer.borderColor = AppColor.PrimaryColors.Gray.color200?.cgColor
        return view
    }()

    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textMd(weight: .regular))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(AssetsIcon.slider, for: .normal)
        button.tintColor = AppColor.PrimaryColors.Gray.color800
        button.isHidden = true
        return button
    }()

    private lazy var pillStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [summaryLabel, filterButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = Layout.pillContentSpacing
        return stack
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [backButton, pillView])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = Layout.spacing
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(contentStack)
        pillView.addSubview(pillStack)

        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)

        [backButton, filterButton].forEach {
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(Layout.iconSize)
            }
        }

        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        pillView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }

        pillStack.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(Layout.pillLeadingInset)
            make.right.equalToSuperview().inset(Layout.pillTrailingInset)
            make.centerY.equalToSuperview()
        }

        snp.makeConstraints { make in
            make.height.equalTo(Layout.height)
        }
    }

    @objc private func backTapped() {
        FeedbackGenerator.onFeedbackGenerator(.soft)
        onBack?()
    }

    @objc private func filterTapped() {
        onFilter?()
    }
}

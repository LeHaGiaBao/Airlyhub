//
//  HelpfulInfoDetailSheetViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

/// Article shown when a "Helpful information" card is tapped: hero image,
/// title, lead paragraph and a bulleted list of facts.
final class HelpfulInfoDetailSheetViewController: BaseBottomSheetViewController {
    private enum Layout {
        static let horizontalInset: CGFloat = 20
        static let heroHeight: CGFloat = 160
        static let bulletSize: CGFloat = 6
        static let maxScrollHeightRatio: CGFloat = 0.55
    }

    private let item: HelpfulInformationItem

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        return scrollView
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()

    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = AppColor.PrimaryColors.Gray.color300
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.PrimaryColors.Gray.color900
        label.numberOfLines = 0
        return label
    }()

    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.PrimaryColors.Gray.color500
        label.numberOfLines = 0
        return label
    }()

    private let factsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("got_it", comment: ""), for: .normal)
        button.applyButtonStyle(.defaultButton(size: .big))
        return button
    }()

    init(item: HelpfulInformationItem) {
        self.item = item
        super.init(configuration: Configuration(showsHandle: true))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func buildContent() {
        setupUI()
        setupEvents()
    }
}

private extension HelpfulInfoDetailSheetViewController {
    func setupUI() {
        titleLabel.text = item.title
        titleLabel.applyTypography(.textXl(weight: .bold))

        summaryLabel.text = item.summary
        summaryLabel.applyTypography(.textSm(weight: .regular))

        heroImageView.image = item.imageName.flatMap { UIImage(named: $0) }
        heroImageView.isHidden = heroImageView.image == nil

        item.facts.forEach { factsStack.addArrangedSubview(makeFactRow(text: $0)) }

        contentStack.addArrangedSubview(heroImageView)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(summaryLabel)
        contentStack.addArrangedSubview(factsStack)
        contentStack.setCustomSpacing(8, after: titleLabel)

        contentView.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        contentView.addSubview(closeButton)

        heroImageView.snp.makeConstraints { make in
            make.height.equalTo(Layout.heroHeight)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(Layout.horizontalInset)
            make.height.lessThanOrEqualTo(Devices.height * Layout.maxScrollHeightRatio)
        }

        contentStack.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(scrollView.frameLayoutGuide).priority(.low)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(Layout.horizontalInset)
            make.height.equalTo(52)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).offset(-24)
        }
    }

    func makeFactRow(text: String) -> UIView {
        let row = UIView()

        let bullet = UIView()
        bullet.backgroundColor = AppColor.PrimaryColors.Primary.color500
        bullet.layer.cornerRadius = Layout.bulletSize / 2

        let label = UILabel()
        label.text = text
        label.textColor = AppColor.PrimaryColors.Gray.color700
        label.numberOfLines = 0
        label.applyTypography(.textSm(weight: .regular))

        row.addSubview(bullet)
        row.addSubview(label)

        bullet.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7)
            make.left.equalToSuperview()
            make.size.equalTo(Layout.bulletSize)
        }

        label.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(bullet.snp.right).offset(12)
        }

        return row
    }
}

private extension HelpfulInfoDetailSheetViewController {
    func setupEvents() {
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }

    @objc func didTapClose() {
        dismissSheet(completion: nil)
    }
}

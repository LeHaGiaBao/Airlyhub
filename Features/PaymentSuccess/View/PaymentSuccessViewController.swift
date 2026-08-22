//
//  PaymentSuccessViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

/// Full-bleed confirmation screen — solid brand blue, the card-with-checkmark
/// artwork, "Paid", a one-line note, and a single way out.
final class PaymentSuccessViewController: BaseViewController {
    var presenter: PaymentSuccessPresenterProtocol!

    private enum Layout {
        static let iconSize: CGFloat = 96
        static let iconTitleSpacing: CGFloat = 24
        static let titleSubtitleSpacing: CGFloat = 8
        static let horizontalPadding: CGFloat = 32
        static let doneBottomInset: CGFloat = 24
        static let doneHeight: CGFloat = 52
    }

    private let cardImageView: UIImageView = {
        let imageView = UIImageView(image: AssetsIcon.payment)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("payment_success_title", comment: "")
        label.applyTypography(.displayXs(weight: .bold))
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("payment_success_subtitle", comment: "")
        label.applyTypography(.textSm(weight: .regular))
        label.textColor = UIColor.white.withAlphaComponent(0.85)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("payment_success_done", comment: ""), for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(AppColor.PrimaryColors.Primary.color500, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 8
        return button
    }()

    private lazy var textStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = Layout.titleSubtitleSpacing
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvents()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private func setupUI() {
        view.backgroundColor = AppColor.PrimaryColors.Primary.color500

        view.addSubview(cardImageView)
        view.addSubview(textStack)
        view.addSubview(doneButton)

        cardImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-Layout.iconSize)
            make.width.height.equalTo(Layout.iconSize)
        }

        textStack.snp.makeConstraints { make in
            make.top.equalTo(cardImageView.snp.bottom).offset(Layout.iconTitleSpacing)
            make.left.right.equalToSuperview().inset(Layout.horizontalPadding)
        }

        doneButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Devices.paddingHorizontal)
            make.height.equalTo(Layout.doneHeight)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Layout.doneBottomInset)
        }
    }

    private func setupEvents() {
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
    }

    @objc private func doneTapped() {
        presenter.didTapDone()
    }
}

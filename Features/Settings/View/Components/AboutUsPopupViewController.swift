//
//  AboutUsPopupViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 19/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class AboutUsPopupViewController: UIViewController {
    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        view.alpha = 0
        return view
    }()

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(AssetsIcon.xcircle, for: .normal)
        button.tintColor = AppColor.PrimaryColors.Gray.color400
        return button
    }()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = AssetsIcon.logo
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = AppInfo.name
        label.applyTypography(.displayXs(weight: .semibold))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        label.textAlignment = .center
        return label
    }()

    private let versionLabel: UILabel = {
        let label = UILabel()
        label.text = String(format: NSLocalizedString("app_version", comment: ""), AppInfo.version)
        label.applyTypography(.textSm(weight: .regular))
        label.textColor = AppColor.PrimaryColors.Gray.color500
        label.textAlignment = .center
        return label
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvents()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(
            withDuration: 0.35,
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0.6,
            options: [.curveEaseOut]
        ) {
            self.dimmingView.alpha = 1
            self.cardView.alpha = 1
            self.cardView.transform = .identity
        }
    }
}

// MARK: - UI
extension AboutUsPopupViewController {
    private func setupUI() {
        view.backgroundColor = .clear

        cardView.alpha = 0
        cardView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)

        view.addSubview(dimmingView)
        view.addSubview(cardView)

        let contentStack = UIStackView(arrangedSubviews: [logoImageView, nameLabel, versionLabel])
        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.spacing = 12
        contentStack.setCustomSpacing(4, after: nameLabel)

        cardView.addSubview(closeButton)
        cardView.addSubview(contentStack)

        dimmingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        cardView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(40)
            make.trailing.lessThanOrEqualToSuperview().offset(-40)
            make.width.equalTo(300)
        }

        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
            make.width.height.equalTo(28)
        }

        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(72)
        }

        contentStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.bottom.equalToSuperview().offset(-32)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
}

// MARK: - Events
extension AboutUsPopupViewController {
    private func setupEvents() {
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)

        let dimTap = UITapGestureRecognizer(target: self, action: #selector(didTapClose))
        dimmingView.addGestureRecognizer(dimTap)
    }

    @objc private func didTapClose() {
        dismissPopup()
    }

    private func dismissPopup() {
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: .curveEaseIn
        ) {
            self.dimmingView.alpha = 0
            self.cardView.alpha = 0
            self.cardView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        } completion: { _ in
            self.dismiss(animated: false) {
                FeedbackGenerator.onFeedbackGenerator(.soft)
            }
        }
    }
}

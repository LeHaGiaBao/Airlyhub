//
//  LogoutConfirmationBottomSheetViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 21/03/2026.
//

import UIKit
import SnapKit

/// Custom bottom sheet: dimmed backdrop + rounded card, primary “Cancel” and outlined “Logout”.
final class LogoutConfirmationBottomSheetViewController: UIViewController {

    var onCancel: (() -> Void)?
    var onLogout: (() -> Void)?

    private let dimmingView = UIView()
    private let sheetContainer = UIView()
    private let titleLabel = UILabel()
    private let cancelButton = UIButton(type: .custom)
    private let logoutButton = UIButton(type: .custom)
    private let buttonStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve

        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimmingView.alpha = 0
        let dimTap = UITapGestureRecognizer(target: self, action: #selector(didTapDimming))
        dimmingView.addGestureRecognizer(dimTap)

        sheetContainer.backgroundColor = .white
        sheetContainer.layer.cornerRadius = 24
        sheetContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        sheetContainer.clipsToBounds = true

        titleLabel.text = NSLocalizedString("logout_confirmation_title", comment: "")
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = AppColor.PrimaryColors.Gray.color800 ?? .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        let primary = AppColor.PrimaryColors.Primary.color500 ?? .systemBlue
        cancelButton.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        cancelButton.backgroundColor = primary
        cancelButton.layer.cornerRadius = 12
        cancelButton.adjustsImageWhenHighlighted = false
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)

        logoutButton.setTitle(NSLocalizedString("logout", comment: ""), for: .normal)
        logoutButton.setTitleColor(primary, for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        logoutButton.backgroundColor = .white
        logoutButton.layer.cornerRadius = 12
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = primary.cgColor
        logoutButton.adjustsImageWhenHighlighted = false
        logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)

        buttonStack.axis = .vertical
        buttonStack.spacing = 12
        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.addArrangedSubview(logoutButton)

        view.addSubview(dimmingView)
        view.addSubview(sheetContainer)
        sheetContainer.addSubview(titleLabel)
        sheetContainer.addSubview(buttonStack)

        dimmingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        sheetContainer.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(sheetContainer.safeAreaLayoutGuide.snp.bottom).offset(-24)
        }

        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        logoutButton.snp.makeConstraints { make in
            make.height.equalTo(52)
        }

        sheetContainer.transform = CGAffineTransform(translationX: 0, y: 400)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(
            withDuration: 0.35,
            delay: 0,
            usingSpringWithDamping: 0.88,
            initialSpringVelocity: 0.6,
            options: [.curveEaseOut]
        ) {
            self.dimmingView.alpha = 1
            self.sheetContainer.transform = .identity
        }
    }

    @objc private func didTapDimming() {
        dismissSheet { [weak self] in
            self?.onCancel?()
        }
    }

    @objc private func didTapCancel() {
        dismissSheet { [weak self] in
            self?.onCancel?()
        }
    }

    @objc private func didTapLogout() {
        dismissSheet { [weak self] in
            self?.onLogout?()
        }
    }

    private func dismissSheet(completion: @escaping () -> Void) {
        UIView.animate(
            withDuration: 0.28,
            delay: 0,
            options: .curveEaseIn
        ) {
            self.dimmingView.alpha = 0
            self.sheetContainer.transform = CGAffineTransform(translationX: 0, y: 400)
        } completion: { _ in
            self.dismiss(animated: false) {
                completion()
            }
        }
    }
}

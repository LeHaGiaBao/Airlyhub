//
//  LogoutConfirmationBottomSheetViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 21/03/2026.
//

import UIKit
import SnapKit

final class LogoutConfirmationBottomSheetViewController: BaseBottomSheetViewController {
    var onCancel: (() -> Void)?
    var onLogout: (() -> Void)?

    private let titleLabel = UILabel()
    private let buttonStack = UIStackView()

    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
        button.applyButtonStyle(.defaultButton(size: .big))
        return button
    }()

    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("logout", comment: ""), for: .normal)
        button.applyButtonStyle(.outlinedButton(size: .big))
        return button
    }()

    override func buildContent() {
        setupUI()
        setupEvents()
    }

    override func didTapDimming() {
        dismissSheet { [weak self] in
            self?.onCancel?()
        }
    }
}

private extension LogoutConfirmationBottomSheetViewController {
    func setupUI() {
        titleLabel.text = NSLocalizedString("logout_confirmation_title", comment: "")
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = AppColor.PrimaryColors.Gray.color800 ?? .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        buttonStack.axis = .vertical
        buttonStack.spacing = 12
        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.addArrangedSubview(logoutButton)

        contentView.addSubview(titleLabel)
        contentView.addSubview(buttonStack)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).offset(-24)
        }

        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        logoutButton.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
    }
}

private extension LogoutConfirmationBottomSheetViewController {
    func setupEvents() {
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
    }

    @objc func didTapCancel() {
        dismissSheet { [weak self] in
            self?.onCancel?()
        }
    }

    @objc func didTapLogout() {
        dismissSheet { [weak self] in
            self?.onLogout?()
        }
    }
}

//
//  DeleteCardConfirmSheetViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

final class DeleteCardConfirmSheetViewController: BaseBottomSheetViewController {
    var onCancel: (() -> Void)?
    var onDelete: (() -> Void)?

    private let cardTitle: String

    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let buttonStack = UIStackView()

    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
        button.applyButtonStyle(.defaultButton(size: .big))
        return button
    }()

    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("delete", comment: ""), for: .normal)
        button.applyButtonStyle(.outlinedButton(size: .big))
        button.setTitleColor(AppColor.PrimaryColors.Error.color500, for: .normal)
        button.tintColor = AppColor.PrimaryColors.Error.color500
        return button
    }()

    init(cardTitle: String) {
        self.cardTitle = cardTitle
        super.init(configuration: Configuration(showsHandle: true))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

private extension DeleteCardConfirmSheetViewController {
    func setupUI() {
        titleLabel.text = NSLocalizedString("delete_card_confirmation_title", comment: "")
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = AppColor.PrimaryColors.Gray.color800 ?? .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        messageLabel.text = String(
            format: NSLocalizedString("delete_card_confirmation_message", comment: ""),
            cardTitle
        )
        messageLabel.applyTypography(.textSm(weight: .regular))
        messageLabel.textColor = AppColor.PrimaryColors.Gray.color500
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        buttonStack.axis = .vertical
        buttonStack.spacing = 12
        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.addArrangedSubview(deleteButton)

        contentView.addSubview(titleLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(buttonStack)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).offset(-24)
        }

        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        deleteButton.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
    }
}

private extension DeleteCardConfirmSheetViewController {
    func setupEvents() {
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
    }

    @objc func didTapCancel() {
        dismissSheet { [weak self] in
            self?.onCancel?()
        }
    }

    @objc func didTapDelete() {
        dismissSheet { [weak self] in
            self?.onDelete?()
        }
    }
}

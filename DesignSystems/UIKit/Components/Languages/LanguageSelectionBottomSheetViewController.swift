//
//  LanguageSelectionBottomSheetViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class LanguageSelectionBottomSheetViewController: BaseBottomSheetViewController {
    private let languages: [AppLanguage]
    private let selectedLanguage: AppLanguage

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("select_language", comment: "")
        label.applyTypography(.textLg(weight: .semibold))
        label.textColor = AppColor.PrimaryColors.Gray.color800 ?? .label
        label.textAlignment = .center
        return label
    }()
    
    private let rowStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    var onSelect: ((AppLanguage) -> Void)?

    init(languages: [AppLanguage], selected: AppLanguage) {
        self.languages = languages
        self.selectedLanguage = selected
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func buildContent() {
        setupUI()
        setupRows()
    }
}

// MARK: - UI
private extension LanguageSelectionBottomSheetViewController {
    func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(rowStack)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        rowStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }

    func setupRows() {
        for language in languages {
            let row = LanguageOptionRow(language: language,
                                        isSelected: language == selectedLanguage)
            row.onTap = { [weak self] selected in
                self?.dismissSheet { self?.onSelect?(selected) }
            }
            rowStack.addArrangedSubview(row)
        }
    }
}

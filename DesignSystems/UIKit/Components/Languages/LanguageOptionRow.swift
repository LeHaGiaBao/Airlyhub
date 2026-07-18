//
//  LanguageOptionRow.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import UIKit

// MARK: - LanguageOptionRow
final class LanguageOptionRow: UIControl {
    var onTap: ((AppLanguage) -> Void)?

    private let language: AppLanguage
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textMd(weight: .medium))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        return label
    }()
    
    private let checkmarkView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "checkmark")
        imgView.contentMode = .scaleAspectFit
        imgView.tintColor = AppColor.PrimaryColors.Primary.color500
        return imgView
    }()

    init(language: AppLanguage, isSelected: Bool) {
        self.language = language
        super.init(frame: .zero)
        setupUI(isSelected: isSelected)
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(isSelected: Bool) {
        backgroundColor = AppColor.BaseColor.backgroundColor?.withAlphaComponent(0.5)
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        addSubview(nameLabel)
        addSubview(checkmarkView)

        snp.makeConstraints { make in
            make.height.equalTo(52)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        checkmarkView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        nameLabel.text = language.displayName
        checkmarkView.isHidden = !isSelected
    }

    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.6 : 1
        }
    }

    @objc private func didTap() {
        onTap?(language)
    }
}

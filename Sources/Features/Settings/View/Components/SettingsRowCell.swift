//
//  SettingsRowCell.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

final class SettingsRowCell: UITableViewCell {
    static let identifier = "SettingsRowCell"

    var onToggleChanged: ((Bool) -> Void)?

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.BaseColor.backgroundColor?.withAlphaComponent(0.5)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()

    private let iconView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textSm(weight: .regular))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textXs(weight: .regular))
        label.textColor = AppColor.PrimaryColors.Gray.color500
        label.isHidden = true
        return label
    }()

    private let toggleSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = AppColor.PrimaryColors.Primary.color500
        toggle.isHidden = true
        return toggle
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupEvents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onToggleChanged = nil
        valueLabel.isHidden = true
        toggleSwitch.isHidden = true
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(containerView)

        containerView.addSubview(iconView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(valueLabel)
        containerView.addSubview(toggleSwitch)

        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(48)
        }

        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }

        valueLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }

        toggleSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }

    private func setupEvents() {
        toggleSwitch.addTarget(self, action: #selector(toggleValueChanged), for: .valueChanged)
    }

    func configure(with item: SettingsItem) {
        titleLabel.text = item.title
        iconView.image = item.icon

        switch item.accessory {
        case .value(let text):
            valueLabel.text = text
            valueLabel.isHidden = false
            toggleSwitch.isHidden = true
        case .toggle(let isOn):
            toggleSwitch.isOn = isOn
            toggleSwitch.isHidden = false
            valueLabel.isHidden = true
        case .none:
            valueLabel.isHidden = true
            toggleSwitch.isHidden = true
        }
    }

    func setToggle(_ isOn: Bool, animated: Bool) {
        toggleSwitch.setOn(isOn, animated: animated)
    }

    @objc private func toggleValueChanged() {
        onToggleChanged?(toggleSwitch.isOn)
    }
}

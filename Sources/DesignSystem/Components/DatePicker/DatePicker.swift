//
//  DatePicker.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 26/04/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class DatePicker: BaseBottomSheetViewController {
    var onConfirm: ((Date) -> Void)?
    var onCancel: (() -> Void)?

    private let pickerMode: UIDatePicker.Mode
    private let initialDate: Date?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("select_date", comment: "")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyTypography(.textLg(weight: .semibold))
        return label
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(AssetsIcon.xcircle, for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        return button
    }()

    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("apply", comment: ""), for: .normal)
        button.applyButtonStyle(.defaultButton(size: .big))
        button.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
        return button
    }()

    private lazy var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = pickerMode
        dp.preferredDatePickerStyle = .wheels
        dp.locale = .current
        dp.translatesAutoresizingMaskIntoConstraints = false
        if let initialDate { dp.date = initialDate }
        return dp
    }()

    var mustBeFutureDate: Bool = false {
        didSet {
            let minimumDate = mustBeFutureDate ? Date() : nil
            datePicker.minimumDate = minimumDate
            datePicker.preferredDatePickerStyle = mustBeFutureDate ? .inline : .wheels
            if let min = minimumDate, datePicker.date < min {
                datePicker.date = min
            }
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init(pickerMode: UIDatePicker.Mode,
         initialDate: Date?) {
        self.pickerMode = pickerMode
        self.initialDate = initialDate
        var configuration = Configuration()
        configuration.sheetBackgroundColor = AppColor.PrimaryColors.Gray.color25 ?? .white
        configuration.showsHandle = true
        super.init(configuration: configuration)
    }

    override func buildContent() {
        setupUI()
    }
}

private extension DatePicker {
    func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(cancelButton)
        contentView.addSubview(confirmButton)
        contentView.addSubview(datePicker)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            datePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            datePicker.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -16),

            confirmButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
}

private extension DatePicker {
    @objc func didTapConfirm() {
        FeedbackGenerator.onFeedbackGenerator(.heavy)
        let date = datePicker.date
        dismissSheet(feedback: nil) { [weak self] in
            self?.onConfirm?(date)
        }
    }

    @objc func didTapCancel() {
        dismissSheet { [weak self] in
            self?.onCancel?()
        }
    }
}

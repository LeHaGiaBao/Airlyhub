//
//  FlightsDateRowView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 26/04/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

protocol FlightsDateRowViewDelegate: AnyObject {
    func dateInputView(_ view: FlightsDateRowView, didSelectDate date: Date)
    func dateInputViewDidTap(_ view: FlightsDateRowView)
    func dateInputViewDidCancel(_ view: FlightsDateRowView)
}

final class FlightsDateRowView: UIView {
    weak var delegate: FlightsDateRowViewDelegate?
    
    var onDateSelected: ((Date) -> Void)?
    
    var placeholder: String = "" {
        didSet {
            updateLabel()
        }
    }
    
    private(set) var selectedDate: Date? {
        didSet {
            updateLabel()
        }
    }
    
    var datePickerMode: UIDatePicker.Mode = .date

    func setDate(_ date: Date?) {
        selectedDate = date
    }
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.PrimaryColors.Gray.color25
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let iconView: UIImageView = {
        let view = UIImageView()
        view.image = AssetsIcon.calendar
        view.contentMode = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.PrimaryColors.Gray.color400
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyTypography(.textMd(weight: .regular))
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupEvent()
    }

    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 8).cgPath
    }
}

// MARK: UI
extension FlightsDateRowView {
    private func setupUI() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 12
        layer.masksToBounds = false
        
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(56)
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(placeholderLabel)
        
        updateLabel()
    }
    
    /// Drops the raised-card chrome so the row can sit inside a container that
    /// draws the surface itself — the tour detail's outlined parameters box, where
    /// the search form's shadow would read as noise on an already-white card.
    func applyFlatStyle() {
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 0
        layer.shadowOpacity = 0
    }

    private func updateLabel() {
        if let date = selectedDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = datePickerMode == .dateAndTime ? .short : .none
            placeholderLabel.setText(formatter.string(from: date))
            placeholderLabel.textColor = AppColor.PrimaryColors.Gray.color800
        } else {
            placeholderLabel.setText(placeholder)
            placeholderLabel.textColor = AppColor.PrimaryColors.Gray.color400
        }
    }
}

// MARK: Event
extension FlightsDateRowView {
    private func setupEvent() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    @objc private func handleTap() {
        guard let vc = findViewController() else { return }
        delegate?.dateInputViewDidTap(self)
        
        let sheet = DatePicker(pickerMode: datePickerMode, initialDate: selectedDate)
        sheet.mustBeFutureDate = true
        
        sheet.onConfirm = { [weak self] date in
            guard let self else { return }
            self.selectedDate = date
            self.delegate?.dateInputView(self, didSelectDate: date)
        }
        
        sheet.onCancel = { [weak self] in
            guard let self else { return }
            self.delegate?.dateInputViewDidCancel(self)
        }
        
        vc.present(sheet, animated: true)
    }
}

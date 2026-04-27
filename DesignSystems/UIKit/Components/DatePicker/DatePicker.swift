//
//  DatePicker.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 26/04/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class DatePicker: UIViewController {
    var onConfirm: ((Date) -> Void)?
    var onCancel: (() -> Void)?
    
    private let pickerMode: UIDatePicker.Mode
    private let initialDate: Date?
    
    private lazy var dimBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSheet))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var sheetView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.PrimaryColors.Gray.color25
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var handleBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2.5
        view.backgroundColor = AppColor.PrimaryColors.Gray.color200
        return view
    }()
    
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
        button.addTarget(self, action: #selector(dismissSheet), for: .touchUpInside)
        return button
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("apply", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColor.PrimaryColors.Primary.color500
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = pickerMode
        dp.preferredDatePickerStyle = .wheels
        dp.locale = .current
        dp.translatesAutoresizingMaskIntoConstraints = false
        if let d = initialDate { dp.date = d }
        return dp
    }()
    
    private var sheetBottomConstraint: NSLayoutConstraint!
    
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
    
    required init?(coder: NSCoder) { fatalError() }
    
    init(pickerMode: UIDatePicker.Mode,
         initialDate: Date?) {
        self.pickerMode = pickerMode
        self.initialDate = initialDate
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatedIn()
    }
}

// MARK: UI
extension DatePicker {
    private func setupUI() {
        view.addSubview(dimBackground)
        view.addSubview(sheetView)
        
        sheetView.addSubview(handleBar)
        sheetView.addSubview(titleLabel)
        sheetView.addSubview(cancelButton)
        sheetView.addSubview(confirmButton)
        sheetView.addSubview(datePicker)
        
        sheetBottomConstraint = sheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 400)
        
        NSLayoutConstraint.activate([
            dimBackground.topAnchor.constraint(equalTo: view.topAnchor),
            dimBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheetBottomConstraint,

            handleBar.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 10),
            handleBar.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
            handleBar.widthAnchor.constraint(equalToConstant: 36),
            handleBar.heightAnchor.constraint(equalToConstant: 5),
            
            titleLabel.topAnchor.constraint(equalTo: handleBar.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 20),
            cancelButton.topAnchor.constraint(equalTo: handleBar.bottomAnchor, constant: 12),
            cancelButton.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -20),
            
            datePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            datePicker.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -16),
            datePicker.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -16),
            
            confirmButton.heightAnchor.constraint(equalToConstant: 50),
            confirmButton.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(
                equalTo: sheetView.safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ])
    }
    
    private func animatedIn() {
        view.layoutIfNeeded()
        sheetBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.35,
                       delay: 0,
                       usingSpringWithDamping: 0.85,
                       initialSpringVelocity: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func animatedOut(completion: @escaping () -> Void) {
        let height = sheetView.bounds.height
        sheetBottomConstraint.constant = height
        UIView.animate(withDuration: 0.25,
                       animations: {
            self.view.layoutIfNeeded()
            self.dimBackground.alpha = 0
        }, completion: { _ in
            completion()
        })
    }
}

// MARK: Events
extension DatePicker {
    @objc private func confirmTapped() {
        FeedbackGenerator.onFeedbackGenerator(.heavy)
        onConfirm?(datePicker.date)
        animatedOut { self.dismiss(animated: false) }
    }
    
    @objc private func dismissSheet() {
        FeedbackGenerator.onFeedbackGenerator(.soft)
        animatedOut {
            self.onCancel?()
            self.dismiss(animated: false)
        }
    }
}

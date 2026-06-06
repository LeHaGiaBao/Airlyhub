//
//  FlightsPassengersRowView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 26/04/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import RxSwift

protocol FlightsPassengersRowViewDelegate: AnyObject {
    func passengersRowDidChange(_ view: FlightsPassengersRowView, count: Int)
}

final class FlightsPassengersRowView: UIView {
    weak var delegate: FlightsPassengersRowViewDelegate?
    private let bag = DisposeBag()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.PrimaryColors.Gray.color25
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let leftStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let stepperStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let smileWink: UIImageView = {
        let imgView = UIImageView()
        imgView.image = AssetsIcon.smileyWink
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("flights_passengers", comment: "")
        label.textColor = AppColor.PrimaryColors.Gray.color800
        label.applyTypography(.textMd(weight: .regular))
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = AppColor.PrimaryColors.Gray.color800
        label.applyTypography(.displayXs(weight: .medium))
        return label
    }()
    
    private let decrementBtn: UIButton = {
        let button = UIButton()
        button.setImage(AssetsIcon.minus, for: .normal)
        return button
    }()
    
    private let increaseBtn: UIButton = {
        let button = UIButton()
        button.setImage(AssetsIcon.plus, for: .normal)
        return button
    }()
    
    private(set) var count: Int = 1 {
        didSet {
            countLabel.text = "\(count)"
        }
    }
    
    private var longPressTimer: Timer?
    private let longPressInterval: TimeInterval = 0.15
    private let longPressInitialDelay: TimeInterval = 0.3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupEvents()
    }

    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        stopLongPressTimer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 8).cgPath
    }
}

// MARK: UI
extension FlightsPassengersRowView {
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
        
        contentView.addSubview(viewStack)
        viewStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        viewStack.addArrangedSubview(leftStack)
        viewStack.addArrangedSubview(stepperStack)
        
        leftStack.addArrangedSubview(smileWink)
        leftStack.addArrangedSubview(titleLabel)
        smileWink.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        
        stepperStack.addArrangedSubview(decrementBtn)
        stepperStack.addArrangedSubview(countLabel)
        stepperStack.addArrangedSubview(increaseBtn)
        setupStepperButton(decrementBtn)
        setupStepperButton(increaseBtn)
        countLabel.text = "\(count)"
    }
    
    private func setupStepperButton(_ button: UIButton) {
        button.tintColor = AppColor.PrimaryColors.Gray.color700
        button.backgroundColor = AppColor.PrimaryColors.Gray.color100
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
    }
}

// MARK: Events
extension FlightsPassengersRowView {
    private func setupEvents() {
        decrementBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.decrement()
            })
            .disposed(by: bag)
        
        increaseBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.increment()
            })
            .disposed(by: bag)
        
        setupLongPressGesture(for: decrementBtn, action: #selector(handleDecrementLongPress(_:)))
        setupLongPressGesture(for: increaseBtn, action: #selector(handleIncreaseLongPress(_:)))
    }
    
    private func setupLongPressGesture(for button: UIButton, action: Selector) {
        let longPress = UILongPressGestureRecognizer(target: self, action: action)
        longPress.minimumPressDuration = longPressInitialDelay
        button.addGestureRecognizer(longPress)
    }
    
    @objc private func handleDecrementLongPress(_ gesture: UILongPressGestureRecognizer) {
        handleLongPress(gesture, isIncrement: false)
    }
    
    @objc private func handleIncreaseLongPress(_ gesture: UILongPressGestureRecognizer) {
        handleLongPress(gesture, isIncrement: true)
    }
    
    private func handleLongPress(_ gesture: UILongPressGestureRecognizer, isIncrement: Bool) {
        switch gesture.state {
        case .began:
            startLongPressTimer(isIncrement: isIncrement)
        case .ended, .cancelled, .failed:
            stopLongPressTimer()
        default:
            break
        }
    }
    
    private func startLongPressTimer(isIncrement: Bool) {
        stopLongPressTimer()
        
        longPressTimer = Timer.scheduledTimer(withTimeInterval: longPressInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if isIncrement {
                self.increment()
            } else {
                self.decrement()
            }
        }
    }
    
    private func stopLongPressTimer() {
        longPressTimer?.invalidate()
        longPressTimer = nil
    }
    
    private func decrement() {
        guard count > 1 else { return }
        FeedbackGenerator.onFeedbackGenerator(.light)
        count -= 1
        delegate?.passengersRowDidChange(self, count: count)
    }
    
    private func increment() {
        FeedbackGenerator.onFeedbackGenerator(.light)
        count += 1
        delegate?.passengersRowDidChange(self, count: count)
    }
}

//
//  ToastView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

// MARK: - ToastView
final class ToastView: UIView {
    private let iconView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.setContentHuggingPriority(.required, for: .horizontal)
        return imgView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.PrimaryColors.Gray.color25 ?? .white
        label.applyTypography(.textSm(weight: .medium))
        label.numberOfLines = 2
        return label
    }()

    private init(message: String, style: ToastStyle) {
        super.init(frame: .zero)
        setupUI(message: message, style: style)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(message: String, style: ToastStyle) {
        backgroundColor = AppColor.PrimaryColors.Gray.color900?.withAlphaComponent(0.95)
            ?? UIColor.black.withAlphaComponent(0.9)
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.18
        layer.shadowRadius = 12
        layer.shadowOffset = CGSize(width: 0, height: 4)
        
        let stack = UIStackView(arrangedSubviews: [iconView, messageLabel])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        addSubview(stack)

        stack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        iconView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        
        messageLabel.text = message
        iconView.image = UIImage(systemName: style.iconName)
        iconView.tintColor = style.iconColor
    }

    /// Shows an auto-dismissing toast pinned above the bottom safe area of `view`.
    static func show(_ message: String,
                     style: ToastStyle = .info,
                     in view: UIView,
                     duration: TimeInterval = 2.2) {
        let toast = ToastView(message: message, style: style)
        toast.alpha = 0
        view.addSubview(toast)

        toast.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualToSuperview().offset(24)
            make.trailing.lessThanOrEqualToSuperview().offset(-24)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
        }

        toast.transform = CGAffineTransform(translationX: 0, y: 20)
        UIView.animate(withDuration: 0.28, delay: 0, options: .curveEaseOut) {
            toast.alpha = 1
            toast.transform = .identity
        }

        UIView.animate(withDuration: 0.28, delay: duration, options: .curveEaseIn) {
            toast.alpha = 0
            toast.transform = CGAffineTransform(translationX: 0, y: 20)
        } completion: { _ in
            toast.removeFromSuperview()
        }
    }
}

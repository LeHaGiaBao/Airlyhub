//
//  LanguageSelectionBottomSheetViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class LanguageSelectionBottomSheetViewController: UIViewController {
    private let languages: [AppLanguage]
    private let selectedLanguage: AppLanguage

    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        view.alpha = 0
        return view
    }()
    
    private let sheetContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.transform = CGAffineTransform(translationX: 0, y: 400)
        view.clipsToBounds = true
        return view
    }()
    
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
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRows()
        setupEvents()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(
            withDuration: 0.35,
            delay: 0,
            usingSpringWithDamping: 0.88,
            initialSpringVelocity: 0.6,
            options: [.curveEaseOut]
        ) {
            self.dimmingView.alpha = 1
            self.sheetContainer.transform = .identity
        }
    }
}

// MARK: - UI
extension LanguageSelectionBottomSheetViewController {
    private func setupUI() {
        view.backgroundColor = .clear
        view.addSubview(dimmingView)
        view.addSubview(sheetContainer)
        
        sheetContainer.addSubview(titleLabel)
        sheetContainer.addSubview(rowStack)

        dimmingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        sheetContainer.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        rowStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(sheetContainer.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }

    private func setupRows() {
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

// MARK: - Events
extension LanguageSelectionBottomSheetViewController {
    @objc private func didTapDimming() {
        dismissSheet(completion: nil)
    }
    
    private func setupEvents() {
        let dimTap = UITapGestureRecognizer(target: self, action: #selector(didTapDimming))
        dimmingView.addGestureRecognizer(dimTap)
    }

    private func dismissSheet(completion: (() -> Void)?) {
        UIView.animate(
            withDuration: 0.28,
            delay: 0,
            options: .curveEaseIn
        ) {
            self.dimmingView.alpha = 0
            self.sheetContainer.transform = CGAffineTransform(translationX: 0, y: 400)
        } completion: { _ in
            self.dismiss(animated: false) {
                FeedbackGenerator.onFeedbackGenerator(.soft)
                completion?()
            }
        }
    }
}

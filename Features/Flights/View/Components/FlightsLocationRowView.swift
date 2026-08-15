//
//  FlightsLocationRowView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 30/05/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

enum LocationField {
    case from, to
}

final class FlightsLocationRowView: UIView {
    var onLocationTap: ((LocationField) -> Void)?

    /// Structured values behind the two labels. The search needs `city` to build a
    /// slug, and that cannot be recovered from the "City, Country" text once it has
    /// been formatted — so both representations are kept, and the swap below has to
    /// move them together.
    private(set) var from: LocationResult?
    private(set) var to: LocationResult?

    private let bag = DisposeBag()
    
    private let fromRowView = FlightsLocationRowItemView(placeholder: NSLocalizedString("from_where", comment: ""))
    private let toRowView = FlightsLocationRowItemView(placeholder: NSLocalizedString("where_to", comment: ""))
    
    private let locationCardView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.PrimaryColors.Gray.color25
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.PrimaryColors.Gray.color100
        return view
    }()
    
    private let swapButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        button.setImage(AssetsIcon.doubleArrow, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.08
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 12
        button.layer.masksToBounds = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupEvents()
    }

    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 12
        layer.masksToBounds = false
        
        addSubview(locationCardView)
        locationCardView.addSubview(fromRowView)
        locationCardView.addSubview(divider)
        locationCardView.addSubview(toRowView)
        
        locationCardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        fromRowView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        divider.snp.makeConstraints { make in
            make.top.equalTo(fromRowView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }

        toRowView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        addSubview(swapButton)
        swapButton.snp.makeConstraints { make in
            make.width.equalTo(32)
            make.height.equalTo(32)
            make.centerY.equalTo(divider.snp.centerY)
            make.trailing.equalTo(locationCardView.snp.trailing).offset(-12)
        }
    }
    
    private func setupEvents() {
        fromRowView.onTap = { [weak self] in
            self?.onLocationTap?(.from)
        }

        toRowView.onTap = { [weak self] in
            self?.onLocationTap?(.to)
        }

        swapButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                guard let self else { return }
                FeedbackGenerator.onFeedbackGenerator(.soft)

                let fromText = self.fromRowView.text
                self.fromRowView.text = self.toRowView.text
                self.toRowView.text = fromText

                // Swapping only the labels would leave the search querying the old
                // direction while the form shows the new one.
                swap(&self.from, &self.to)
            }
            .disposed(by: bag)
    }

    func setLocation(_ result: LocationResult, for field: LocationField) {
        let text = "\(result.city), \(result.country)"
        switch field {
        case .from:
            from = result
            fromRowView.text = text
        case .to:
            to = result
            toRowView.text = text
        }
    }
}

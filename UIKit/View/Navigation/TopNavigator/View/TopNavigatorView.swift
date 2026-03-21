//
//  TopNavigatorView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TopNavigatorView: UIViewController {
    private let bag = DisposeBag()
    
    private var topNavigatorTile: String {
        didSet {
            titleLabel.text = topNavigatorTile
        }
    }
    
    private let navigatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private let arrowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setImage(AssetsIcon.arrowLeft, for: .normal)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.applyTypography(.textMd(weight: .medium))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        label.textAlignment = .center
        return label
    }()
    
    var onCloseAction: (() -> Void)?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(topNavigatorTile: String) {
        self.topNavigatorTile = topNavigatorTile
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = topNavigatorTile
        
        setupUI()
        updateEvent()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(navigatorView)
        navigatorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        navigatorView.addSubview(arrowButton)
        arrowButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalTo(24)
        }

        navigatorView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func updateEvent() {
        arrowButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                FeedbackGenerator.onFeedbackGenerator(.soft)
                self?.onCloseAction?()
            }
            .disposed(by: bag)
    }
}

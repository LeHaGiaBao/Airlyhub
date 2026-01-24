//
//  ExploreViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import UIKit

final class ExploreViewController: BaseViewController {
    var presenter: ExplorePresenterProtocol!
    
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let searchView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        setupSearchView()
    }
}

extension ExploreViewController: ExploreViewProtocol {
    private func setupSearchView() {
        view.addSubview(searchView)
        searchView.backgroundColor = .white
        
        setupTitle()
        setupSubTitle()
        
        NSLayoutConstraint.activate([
            searchView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(20)),
            searchView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: CGFloat(20))
        ])
    }
    
    private func setupTitle() {
        titleLabel.text = NSLocalizedString("extreme", comment: "")
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = AppColor.PrimaryColors.Primary.color500
        titleLabel.applyTypography(.displaySm(weight: .bold))

        searchView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(98)),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(20))
        ])
    }
    
    private func setupSubTitle() {
        subTitleLabel.text = NSLocalizedString("airplane_flight", comment: "")
        subTitleLabel.textAlignment = .left
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.textColor = AppColor.PrimaryColors.Gray.color700
        subTitleLabel.applyTypography(.displaySm(weight: .bold))

        searchView.addSubview(subTitleLabel)
        
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: CGFloat(4)),
            subTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(20))
        ])
    }
}

//
//  FavoritesViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import UIKit

final class FavoritesViewController: BaseViewController {
    var presenter: FavoritesPresenterProtocol!
    
    private let titleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = .white
        setupTitle()
    }
}

extension FavoritesViewController: FavoritesViewProtocol {
    private func setupTitle() {
        titleLabel.text = NSLocalizedString("favorites", comment: "")
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = AppColor.PrimaryColors.Gray.color700
        titleLabel.applyTypography(.displaySm(weight: .bold))

        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(98)),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(20))
        ])
    }
}

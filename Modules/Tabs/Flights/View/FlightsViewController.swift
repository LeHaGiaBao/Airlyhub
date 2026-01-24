//
//  FlightsViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import UIKit

final class FlightsViewController: BaseViewController {
    var presenter: FlightsPresenterProtocol!

    private let titleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        title = "Flights"

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)

        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension FlightsViewController: FlightsViewProtocol {
    func showTitle(_ title: String) {
        titleLabel.text = title
    }
}

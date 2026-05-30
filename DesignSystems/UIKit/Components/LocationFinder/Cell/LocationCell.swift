//
//  LocationCell.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 30/05/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import UIKit

final class LocationCell: UITableViewCell {
    static let reuseID = "LocationCell"

    private let pinIcon: UIImageView = {
        let img = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .light)
        img.image = AssetsIcon.map
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()

    private let cityLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textMd(weight: .regular))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let countryLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textSm(weight: .regular))
        label.textColor = AppColor.PrimaryColors.Gray.color400
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        let stack = UIStackView(arrangedSubviews: [cityLabel, countryLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(pinIcon)
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            pinIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            pinIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pinIcon.widthAnchor.constraint(equalToConstant: 24),
            pinIcon.heightAnchor.constraint(equalToConstant: 24),

            stack.leadingAnchor.constraint(equalTo: pinIcon.trailingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with result: LocationResult) {
        cityLabel.text = result.city
        countryLabel.text = result.country
    }
}

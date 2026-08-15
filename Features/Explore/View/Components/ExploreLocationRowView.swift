//
//  ExploreLocationRowView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 10/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import UIKit

final class ExploreLocationRowView: UIView {
    var onLocationTap: (() -> Void)?

    /// Kept alongside the displayed text because the search needs the structured
    /// value — `TourSlug` works off `city`, which cannot be recovered from the
    /// "City, Country" label once it has been formatted.
    private(set) var location: LocationResult?

    private let locationRowView = FlightsLocationRowItemView(
        placeholder: NSLocalizedString("explore_location_placeholder", comment: "")
    )

    private let locationCardView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.PrimaryColors.Gray.color25
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupEvents()
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 8).cgPath
    }

    private func setupUI() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 12
        layer.masksToBounds = false

        addSubview(locationCardView)
        locationCardView.addSubview(locationRowView)

        locationCardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        locationRowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupEvents() {
        locationRowView.onTap = { [weak self] in
            self?.onLocationTap?()
        }
    }

    func setLocation(_ result: LocationResult) {
        location = result
        locationRowView.text = "\(result.city), \(result.country)"
    }
}

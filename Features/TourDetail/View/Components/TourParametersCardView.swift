//
//  TourParametersCardView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

/// The "Tour parameters" card: a trip-level place-or-date row, then the passenger
/// count.
///
/// The first row is the one place the tour/flight split shows up as a type check
/// rather than an optional field collapsing — a static city label and a tappable
/// date picker are different enough controls that no single view renders both.
/// Reuses `FlightsDateRowView` and `FlightsPassengersRowView` as-is: they are
/// already generic, and `SearchFilterBottomSheetViewController` sets the precedent
/// of a screen outside Flights using them directly rather than re-creating them.
final class TourParametersCardView: UIView {
    private enum Layout {
        static let rowHeight: CGFloat = 56
        static let horizontalPadding: CGFloat = 12
        static let iconSpacing: CGFloat = 12
        static let stackSpacing: CGFloat = 12
    }

    var onDateSelected: ((Date) -> Void)?
    var onPassengersChange: ((Int) -> Void)?

    private let originIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = AssetsIcon.location
        imageView.contentMode = .left
        imageView.tintColor = AppColor.PrimaryColors.Gray.color400
        return imageView
    }()

    private let originLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textMd(weight: .regular))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        return label
    }()

    private lazy var originContent: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [originIcon, originLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = Layout.iconSpacing
        return stack
    }()

    /// Read-only — a tour's origin is fixed, so unlike `dateRow` this has no tap
    /// handler and no delegate of its own.
    private lazy var originRow: UIView = {
        let row = UIView()
        row.backgroundColor = AppColor.PrimaryColors.Gray.color25
        row.layer.cornerRadius = 8
        row.clipsToBounds = true
        row.addSubview(originContent)

        originContent.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Layout.horizontalPadding)
            make.centerY.equalToSuperview()
        }
        row.snp.makeConstraints { make in
            make.height.equalTo(Layout.rowHeight)
        }
        return row
    }()

    private let dateRow = FlightsDateRowView()

    private lazy var passengersView: FlightsPassengersRowView = {
        let view = FlightsPassengersRowView()
        view.delegate = self
        return view
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [originRow, dateRow, passengersView])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = Layout.stackSpacing
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: TourDetailViewModel) {
        let isTour = viewModel.originText != nil
        originRow.isHidden = !isTour
        dateRow.isHidden = isTour

        originLabel.text = viewModel.originText
        if let date = viewModel.date {
            dateRow.setDate(date)
        }
        passengersView.setCount(viewModel.passengers)
    }

    private func setupUI() {
        dateRow.placeholder = NSLocalizedString("flights_departure_date", comment: "")

        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - FlightsDateRowViewDelegate
extension TourParametersCardView: FlightsDateRowViewDelegate {
    func dateInputView(_ view: FlightsDateRowView, didSelectDate date: Date) {
        onDateSelected?(date)
    }

    func dateInputViewDidTap(_ view: FlightsDateRowView) {}
    func dateInputViewDidCancel(_ view: FlightsDateRowView) {}
}

// MARK: - FlightsPassengersRowViewDelegate
extension TourParametersCardView: FlightsPassengersRowViewDelegate {
    func passengersRowDidChange(_ view: FlightsPassengersRowView, count: Int) {
        onPassengersChange?(count)
    }
}

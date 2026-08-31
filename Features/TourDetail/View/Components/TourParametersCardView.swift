//
//  TourParametersCardView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

/// The "Tour parameters" box: a trip-level place-or-date row, then the passenger
/// count, joined by a hairline inside one outlined container.
///
/// One container rather than the free-standing raised rows the search form uses —
/// those rows sit on the app's grey background, where a shadow reads as elevation,
/// while here they sit on a white card, where the same shadow reads as noise. The
/// rows themselves are still `FlightsDateRowView` and `FlightsPassengersRowView`,
/// flattened through `applyFlatStyle()` so the border draws the surface instead of
/// each row drawing its own.
///
/// The first row is the one place the tour/flight split shows up as a type check
/// rather than an optional field collapsing — a static city label and a tappable
/// date picker are different enough controls that no single view renders both.
final class TourParametersCardView: UIView {
    private enum Layout {
        static let rowHeight: CGFloat = 56
        static let horizontalPadding: CGFloat = 12
        static let iconSpacing: CGFloat = 12
        static let iconSize: CGFloat = 24
        static let cornerRadius: CGFloat = 12
        static let separatorHeight: CGFloat = 1
    }

    var onDateSelected: ((Date) -> Void)?
    var onPassengersChange: ((Int) -> Void)?

    private let originIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = AssetsIcon.calendar
        imageView.contentMode = .scaleAspectFit
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
        row.addSubview(originContent)

        originIcon.snp.makeConstraints { make in
            make.width.height.equalTo(Layout.iconSize)
        }
        originContent.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Layout.horizontalPadding)
            make.right.lessThanOrEqualToSuperview().inset(Layout.horizontalPadding)
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

    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.PrimaryColors.Gray.color200
        return view
    }()

    private lazy var rowsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [originRow, dateRow, separator, passengersView])
        stack.axis = .vertical
        stack.alignment = .fill
        // Zero: the separator is the only thing that should show between rows.
        stack.spacing = 0
        return stack
    }()

    private let boxView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Layout.cornerRadius
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColor.PrimaryColors.Gray.color200?.cgColor
        view.clipsToBounds = true
        return view
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

        originLabel.setText(viewModel.originText)
        if let date = viewModel.date {
            dateRow.setDate(date)
        }
        passengersView.setCount(viewModel.passengers)
    }

    private func setupUI() {
        dateRow.placeholder = NSLocalizedString("flights_departure_date", comment: "")
        dateRow.delegate = self
        dateRow.applyFlatStyle()
        passengersView.applyFlatStyle()

        addSubview(boxView)
        boxView.addSubview(rowsStack)

        boxView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        rowsStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        separator.snp.makeConstraints { make in
            make.height.equalTo(Layout.separatorHeight)
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

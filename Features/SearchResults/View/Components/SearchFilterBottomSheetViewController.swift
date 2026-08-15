//
//  SearchFilterBottomSheetViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

/// Reopens the search form over the results so the user can adjust it without
/// going back.
///
/// The rows are the same components the Explore and Flights screens are built
/// from — `ExploreLocationRowView`, `FlightsLocationRowView`, `FlightsDateRowView`
/// and `FlightsPassengersRowView`. Re-creating them for the sheet would mean two
/// pickers, two validation rules and two places to keep the styling in step.
final class SearchFilterBottomSheetViewController: BaseBottomSheetViewController {
    /// Fires after the sheet has closed, with the edited criteria. Not called when
    /// the user dismisses without applying.
    var onApply: ((SearchCriteria) -> Void)?

    private enum Layout {
        static let topPadding: CGFloat = 24
        static let bottomPadding: CGFloat = 24
        static let rowSpacing: CGFloat = 12
        static let buttonSpacing: CGFloat = 24
    }

    private var criteria: SearchCriteria

    /// Which location control the sheet shows — one field for a tour, two for a
    /// flight. Built up front so `buildContent` stays a straight layout pass.
    private lazy var tourLocationView = ExploreLocationRowView()
    private lazy var flightLocationView = FlightsLocationRowView()

    private lazy var dateView: FlightsDateRowView = {
        let view = FlightsDateRowView()
        view.placeholder = NSLocalizedString("select_date", comment: "")
        view.datePickerMode = .date
        view.delegate = self
        return view
    }()

    private lazy var passengersView: FlightsPassengersRowView = {
        let view = FlightsPassengersRowView()
        view.delegate = self
        return view
    }()

    private let applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("apply", comment: ""), for: .normal)
        button.applyButtonStyle(.defaultButton(size: .big))
        return button
    }()

    init(criteria: SearchCriteria) {
        self.criteria = criteria
        super.init(configuration: Configuration(showsHandle: true))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func buildContent() {
        let locationView: UIView = criteria.type == .tour ? tourLocationView : flightLocationView

        let stack = UIStackView(arrangedSubviews: [
            locationView,
            dateView,
            passengersView,
            applyButton
        ])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = Layout.rowSpacing
        stack.setCustomSpacing(Layout.buttonSpacing, after: passengersView)

        contentView.addSubview(stack)

        stack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Layout.topPadding)
            make.left.right.equalToSuperview().inset(Devices.paddingHorizontal)
            // Safe area, so the button clears the home indicator.
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(Layout.bottomPadding)
        }

        applyButton.addTarget(self, action: #selector(applyTapped), for: .touchUpInside)

        setupLocationEvents()
        prefill()
    }

    // MARK: - State

    private func prefill() {
        if let origin = criteria.origin {
            switch criteria.type {
            case .tour:
                tourLocationView.setLocation(origin)
            case .flight:
                flightLocationView.setLocation(origin, for: .from)
            }
        }

        if let destination = criteria.destination {
            flightLocationView.setLocation(destination, for: .to)
        }

        dateView.setDate(criteria.date)
        passengersView.setCount(criteria.passengers)
    }

    private func setupLocationEvents() {
        tourLocationView.onLocationTap = { [weak self] in
            self?.presentLocationFinder { criteria, location in
                criteria.origin = location
            }
        }

        flightLocationView.onLocationTap = { [weak self] field in
            self?.presentLocationFinder { criteria, location in
                switch field {
                case .from: criteria.origin = location
                case .to:   criteria.destination = location
                }
            }
        }
    }

    /// - Parameter assign: writes the picked location into the right slot. Passing a
    ///   mutating closure keeps the two call sites above to one line each rather
    ///   than repeating the present-and-store dance.
    ///
    /// `prefill` is re-run afterwards, which is only safe because every control
    /// writes straight back into `criteria` as the user touches it. Were the stepper
    /// or the date read at Apply time instead, redrawing here would quietly undo
    /// whatever the user had changed before picking a location.
    private func presentLocationFinder(assign: @escaping (inout SearchCriteria, LocationResult) -> Void) {
        let picker = LocationFinder()
        picker.onConfirm = { [weak self] location in
            guard let self else { return }
            assign(&self.criteria, location)
            self.prefill()
        }
        present(picker, animated: true)
    }

    @objc private func applyTapped() {
        guard criteria.isComplete else {
            ToastView.show(
                NSLocalizedString("search_incomplete", comment: ""),
                style: .info,
                in: view
            )
            return
        }

        let applied = criteria
        dismissSheet { [weak self] in
            self?.onApply?(applied)
        }
    }
}

// MARK: - FlightsDateRowViewDelegate
extension SearchFilterBottomSheetViewController: FlightsDateRowViewDelegate {
    func dateInputView(_ view: FlightsDateRowView, didSelectDate date: Date) {
        criteria.date = date
    }

    func dateInputViewDidTap(_ view: FlightsDateRowView) {}

    func dateInputViewDidCancel(_ view: FlightsDateRowView) {}
}

// MARK: - FlightsPassengersRowViewDelegate
extension SearchFilterBottomSheetViewController: FlightsPassengersRowViewDelegate {
    func passengersRowDidChange(_ view: FlightsPassengersRowView, count: Int) {
        criteria.passengers = count
    }
}

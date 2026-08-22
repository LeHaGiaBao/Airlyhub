//
//  RouteTimelineView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

/// The dotted vertical line under "Flight route" — a dot and a stop name per row,
/// joined into one continuous line down the left edge.
///
/// Takes plain waypoint names rather than distinguishing tour stops from a flight's
/// single destination — a tour's four-stop excursion and a flight's one-stop hop
/// through the same list, which is what lets `TourDetailViewController` use one
/// view for both. The airfield the route starts from is not one of these rows; it
/// is shown separately, above this view, as the departure point.
final class RouteTimelineView: UIView {
    private enum Layout {
        static let rowHeight: CGFloat = 32
        static let dotSize: CGFloat = 8
        static let lineWidth: CGFloat = 1.5
        static let labelSpacing: CGFloat = 12
    }

    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        // Zero spacing is what keeps the line unbroken between rows — each row's
        // own line already runs from its dot to the row's bottom edge.
        stack.spacing = 0
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(waypoints: [String]) {
        stack.arrangedSubviews.forEach {
            stack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        waypoints.enumerated().forEach { index, name in
            stack.addArrangedSubview(makeRow(text: name, isLast: index == waypoints.count - 1))
        }
    }

    private func setupUI() {
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func makeRow(text: String, isLast: Bool) -> UIView {
        let container = UIView()

        let dot: UIView = {
            let view = UIView()
            view.backgroundColor = AppColor.PrimaryColors.Primary.color500
            view.layer.cornerRadius = Layout.dotSize / 2
            return view
        }()

        let line: UIView = {
            let view = UIView()
            view.backgroundColor = AppColor.PrimaryColors.Gray.color300
            view.isHidden = isLast
            return view
        }()

        let label: UILabel = {
            let label = UILabel()
            label.text = text
            label.applyTypography(.textSm(weight: .regular))
            label.textColor = AppColor.PrimaryColors.Gray.color800
            return label
        }()

        container.addSubview(line)
        container.addSubview(dot)
        container.addSubview(label)

        container.snp.makeConstraints { make in
            make.height.equalTo(Layout.rowHeight)
        }

        dot.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.height.equalTo(Layout.dotSize)
        }

        line.snp.makeConstraints { make in
            make.top.equalTo(dot.snp.bottom)
            make.bottom.equalToSuperview()
            make.centerX.equalTo(dot)
            make.width.equalTo(Layout.lineWidth)
        }

        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(dot.snp.right).offset(Layout.labelSpacing)
            make.right.equalToSuperview()
        }

        return container
    }
}

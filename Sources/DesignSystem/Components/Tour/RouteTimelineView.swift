//
//  RouteTimelineView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

/// The vertical line under "Flight route" — a hollow ring and a stop name per row,
/// joined into one continuous line down the left edge.
final class RouteTimelineView: UIView {
    private enum Layout {
        static let rowHeight: CGFloat = 44
        static let dotSize: CGFloat = 10
        static let dotBorderWidth: CGFloat = 2
        static let lineWidth: CGFloat = 1.5
        static let labelSpacing: CGFloat = 16
    }

    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
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
            stack.addArrangedSubview(
                makeRow(text: name, isFirst: index == 0, isLast: index == waypoints.count - 1)
            )
        }
    }

    private func setupUI() {
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func makeRow(text: String, isFirst: Bool, isLast: Bool) -> UIView {
        let container = UIView()

        let dot: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = Layout.dotSize / 2
            view.layer.borderWidth = Layout.dotBorderWidth
            view.layer.borderColor = AppColor.PrimaryColors.Primary.color500?.cgColor
            return view
        }()

        let topLine = makeLine(isHidden: isFirst)
        let bottomLine = makeLine(isHidden: isLast)

        let label: UILabel = {
            let label = UILabel()
            label.text = text
            label.applyTypography(.textMd(weight: .regular))
            label.textColor = AppColor.PrimaryColors.Gray.color800
            return label
        }()

        container.addSubview(topLine)
        container.addSubview(bottomLine)
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

        topLine.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(dot.snp.top)
            make.centerX.equalTo(dot)
            make.width.equalTo(Layout.lineWidth)
        }

        bottomLine.snp.makeConstraints { make in
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

    private func makeLine(isHidden: Bool) -> UIView {
        let view = UIView()
        view.backgroundColor = AppColor.PrimaryColors.Primary.color500
        view.isHidden = isHidden
        return view
    }
}

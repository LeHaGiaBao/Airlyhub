//
//  PillSelectorScrollView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

/// A `SegmentedPillView` that scrolls instead of stopping at the screen edge, and
/// that can be re-titled after construction.
final class PillSelectorScrollView: UIView {
    var onSelect: ((Int) -> Void)?

    private(set) var selectedIndex: Int = 0

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()

    private var pillView: SegmentedPillView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(titles: [String], selectedIndex: Int) {
        pillView?.removeFromSuperview()

        let pillView = SegmentedPillView(titles: titles, selectedIndex: selectedIndex)
        pillView.onSelect = { [weak self] index in
            self?.selectedIndex = index
            self?.onSelect?(index)
        }
        self.pillView = pillView
        self.selectedIndex = selectedIndex

        scrollView.addSubview(pillView)
        pillView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.equalTo(scrollView.frameLayoutGuide)
        }
    }

    private func setupUI() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

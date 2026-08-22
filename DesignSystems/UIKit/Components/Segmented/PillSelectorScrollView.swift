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
///
/// `SegmentedPillView` itself stays fixed-width and fixed-title — the Favorites tab
/// switch it was built for always fits two pills on screen and never changes them.
/// The tour detail screen's duration and departure-time rows don't have either
/// guarantee: five pills routinely run past the screen edge, and the titles
/// themselves are unknown until the record finishes loading, well after this view
/// is constructed. Composing rather than modifying `SegmentedPillView` keeps that
/// view's simpler contract intact for its one existing caller.
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

    /// Rebuilds the pills from scratch — cheap enough for the handful of options a
    /// duration or departure-time row ever holds, and simpler than diffing titles
    /// against whatever the previous record showed. Same trade-off
    /// `TourBadgeStripView.configure` makes for its chips.
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
            // Pinned to the content guide on every edge but height, which is
            // pinned to the frame guide instead — that is what lets the row grow
            // wider than the screen without also growing taller than its pills.
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

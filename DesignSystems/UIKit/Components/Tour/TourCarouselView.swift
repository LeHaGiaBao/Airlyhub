//
//  TourCarouselView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

/// Titled horizontal rail of compact tour tiles — the "Popular" block on Explore.
///
/// A collection view here, unlike `TourSectionView`'s stack: the rail scrolls on its
/// own axis so it never competes with the page's vertical scrolling, and the item
/// count is open-ended enough that recycling earns its keep.
final class TourCarouselView: UIView {
    private enum Layout {
        static let titleSpacing: CGFloat = 20
        static let itemSpacing: CGFloat = 12
    }

    var onSelectItem: ((String) -> Void)?

    private var items: [TourCardModel] = []

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.PrimaryColors.Gray.color800
        
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = TourCarouselCell.itemSize
        layout.minimumLineSpacing = Layout.itemSpacing

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.register(TourCarouselCell.self, forCellWithReuseIdentifier: TourCarouselCell.reuseID)
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()

    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        titleLabel.applyTypography(.textXl(weight: .bold))
        setupUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(titleLabel)
        addSubview(collectionView)

        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Layout.titleSpacing)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(TourCarouselCell.itemSize.height)
        }
    }

    func configure(with items: [TourCardModel]) {
        self.items = items
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension TourCarouselView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TourCarouselCell.reuseID,
            for: indexPath
        ) as? TourCarouselCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: items[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension TourCarouselView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelectItem?(items[indexPath.item].id)
    }
}

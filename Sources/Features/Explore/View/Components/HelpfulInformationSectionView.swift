//
//  HelpfulInformationSectionView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

/// White panel at the bottom of the Explore screen holding the
/// horizontally scrolling "Helpful information" cards.
final class HelpfulInformationSectionView: UIView {
    private enum Layout {
        static let cornerRadius: CGFloat = 20
        static let topPadding: CGFloat = 20
        static let titleSpacing: CGFloat = 24
        static let itemSpacing: CGFloat = 12
    }

    var onSelectItem: ((HelpfulInformationItem) -> Void)?

    private var items: [HelpfulInformationItem] = []

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("helpful_information", comment: "")
        label.textColor = AppColor.PrimaryColors.Gray.color800
        label.applyTypography(.textXl(weight: .bold))
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = HelpfulInformationCell.itemSize
        layout.minimumLineSpacing = Layout.itemSpacing
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: Devices.paddingHorizontal,
            bottom: 0,
            right: Devices.paddingHorizontal
        )

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.register(HelpfulInformationCell.self, forCellWithReuseIdentifier: HelpfulInformationCell.reuseID)
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: Layout.cornerRadius
        ).cgPath
    }

    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = Layout.cornerRadius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: -4)
        layer.shadowRadius = 12

        addSubview(titleLabel)
        addSubview(collectionView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Layout.topPadding)
            make.left.right.equalToSuperview().inset(Devices.paddingHorizontal)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Layout.titleSpacing)
            make.left.right.equalToSuperview()
            make.height.equalTo(HelpfulInformationCell.itemSize.height)
        }
    }

    func configure(with items: [HelpfulInformationItem]) {
        self.items = items
        collectionView.reloadData()
    }
}

extension HelpfulInformationSectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HelpfulInformationCell.reuseID,
            for: indexPath
        ) as? HelpfulInformationCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: items[indexPath.item])
        return cell
    }
}

extension HelpfulInformationSectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelectItem?(items[indexPath.item])
    }
}

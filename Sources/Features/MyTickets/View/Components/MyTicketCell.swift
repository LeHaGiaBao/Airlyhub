//
//  MyTicketCell.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 17/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class MyTicketCell: UITableViewCell {
    static let reuseID = "MyTicketCell"

    private let cardView = SmallTicket()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(20)
        }
    }

    func configure(with ticket: SmallTicketModel) {
        cardView.configure(with: ticket)
    }
}

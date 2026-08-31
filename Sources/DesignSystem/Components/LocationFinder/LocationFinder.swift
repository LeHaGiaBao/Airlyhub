//
//  LocationFinder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 30/05/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import UIKit

final class LocationFinder: BaseBottomSheetViewController {
    var onConfirm: ((LocationResult) -> Void)?
    var onCancel: (() -> Void)?
    var searchWorkItem: DispatchWorkItem?

    var results: [LocationResult] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    let searchContainerView: TextField = {
        let field = TextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = NSLocalizedString("search_location_placeholder", comment: "")
        field.setLeadingIcon(AssetsIcon.search)
        field.textField.keyboardType = .default
        field.textField.autocapitalizationType = .none
        field.textField.autocorrectionType = .no
        field.textField.textContentType = .location
        field.textField.returnKeyType = .done
        return field
    }()

    lazy var myLocationRow: UIView = myLocationRowView()

    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.93, alpha: 1)
        return view
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.register(LocationCell.self, forCellReuseIdentifier: LocationCell.reuseID)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init() {
        var configuration = Configuration()
        configuration.showsHandle = true
        configuration.avoidsKeyboard = true
        configuration.animationOffset = 600
        super.init(configuration: configuration)
    }

    override func buildContent() {
        setupUI()
        searchContainerView.textField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchContainerView.textField.becomeFirstResponder()
    }

    override func didTapDimming() {
        searchWorkItem?.cancel()
        searchContainerView.textField.resignFirstResponder()
        dismissSheet { [weak self] in
            self?.onCancel?()
        }
    }
}

extension LocationFinder {
    func updateResults(_ results: [LocationResult]) {
        self.results = results
    }
}

extension LocationFinder {
    func setupUI() {
        contentView.addSubview(searchContainerView)
        contentView.addSubview(myLocationRow)
        contentView.addSubview(separatorView)
        contentView.addSubview(tableView)

        NSLayoutConstraint.activate([
            searchContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            searchContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            searchContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            myLocationRow.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 4),
            myLocationRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            myLocationRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            myLocationRow.heightAnchor.constraint(equalToConstant: 56),

            separatorView.topAnchor.constraint(equalTo: myLocationRow.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 4),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 300),
            tableView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
}

extension LocationFinder {
    func myLocationRowView() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(myLocationTapped))
        container.addGestureRecognizer(tap)

        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.image = AssetsIcon.location
        iconView.contentMode = .scaleAspectFit

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("my_location", comment: "")
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label

        container.addSubview(iconView)
        container.addSubview(label)

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),

            label.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        return container
    }
}

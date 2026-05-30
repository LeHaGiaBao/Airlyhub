//
//  LocationFinder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 30/05/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import UIKit

final class LocationFinder: UIViewController {
    var onConfirm: ((LocationResult) -> Void)?
    var onCancel: (() -> Void)?
    var searchWorkItem: DispatchWorkItem?

    var results: [LocationResult] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    lazy var dimBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSheet))
        view.addGestureRecognizer(tap)
        return view
    }()

    lazy var sheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var handleBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2.5
        view.backgroundColor = UIColor(white: 0.8, alpha: 1)
        return view
    }()
    
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

    var sheetBottomConstraint: NSLayoutConstraint!

    required init?(coder: NSCoder) { fatalError() }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupUI()
        observeKeyboard()
        searchContainerView.textField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateIn()
        searchContainerView.textField.becomeFirstResponder()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Public API
extension LocationFinder {
    func updateResults(_ results: [LocationResult]) {
        self.results = results
    }
}

// MARK: - SetupUI
extension LocationFinder {
    func setupUI() {
        view.addSubview(dimBackground)
        view.addSubview(sheetView)

        sheetView.addSubview(handleBar)
        sheetView.addSubview(searchContainerView)
        sheetView.addSubview(myLocationRow)
        sheetView.addSubview(separatorView)
        sheetView.addSubview(tableView)

        sheetBottomConstraint = sheetView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor, constant: 600)

        NSLayoutConstraint.activate([
            // Dim
            dimBackground.topAnchor.constraint(equalTo: view.topAnchor),
            dimBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Sheet
            sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheetBottomConstraint,

            // Handle bar
            handleBar.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 10),
            handleBar.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
            handleBar.widthAnchor.constraint(equalToConstant: 36),
            handleBar.heightAnchor.constraint(equalToConstant: 5),

            // Search container — height driven by TextField's internal InputTokens.height (49pt)
            searchContainerView.topAnchor.constraint(equalTo: handleBar.bottomAnchor, constant: 16),
            searchContainerView.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 16),
            searchContainerView.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -16),

            // My location row
            myLocationRow.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 4),
            myLocationRow.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor),
            myLocationRow.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor),
            myLocationRow.heightAnchor.constraint(equalToConstant: 56),

            // Separator
            separatorView.topAnchor.constraint(equalTo: myLocationRow.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            // TableView
            tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 4),
            tableView.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 300),
            tableView.bottomAnchor.constraint(equalTo: sheetView.safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ])
    }
}

// MARK: My Location View
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
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])
        return container
    }
}

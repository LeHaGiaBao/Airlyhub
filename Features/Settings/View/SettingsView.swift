//
//  SettingsView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import UIKit
import SnapKit

final class SettingsView: BaseViewController, SettingsViewProtocol {
    private let presenter: SettingsPresenter
    private let topNavigatorVC: TopNavigatorView
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var items: [SettingsItem] = []

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(presenter: SettingsPresenter) {
        self.presenter = presenter
        self.topNavigatorVC = TopNavigatorView(topNavigatorTile: NSLocalizedString("settings", comment: ""))
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        embedTopNavigator()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        presenter.viewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
    }

    private func embedTopNavigator() {
        addChild(topNavigatorVC)
        view.addSubview(topNavigatorVC.view)
        topNavigatorVC.view.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(56)
        }
        
        topNavigatorVC.didMove(toParent: self)
        topNavigatorVC.onCloseAction = { [weak self] in
            self?.presenter.dismiss()
        }
    }

    private func setupTableView() {
        items = presenter.getSettingItems()

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 68
        tableView.isScrollEnabled = false
        tableView.register(SettingsRowCell.self, forCellReuseIdentifier: SettingsRowCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topNavigatorVC.view.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(CGFloat(items.count) * 68)
        }
    }
}

// MARK: - SettingsViewProtocol
extension SettingsView {
    func setPushNotificationToggle(_ isOn: Bool) {
        guard let row = items.firstIndex(where: { $0.type == .pushNotifications }) else { return }
        let indexPath = IndexPath(row: row, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? SettingsRowCell else { return }
        cell.setToggle(isOn, animated: true)
    }

    func showToast(_ message: String, style: ToastStyle) {
        ToastView.show(message, style: style, in: view)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SettingsView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsRowCell.identifier,
            for: indexPath
        ) as? SettingsRowCell else {
            return UITableViewCell()
        }

        let item = items[indexPath.row]
        cell.configure(with: item)

        if item.type == .pushNotifications {
            cell.onToggleChanged = { [weak self] isOn in
                self?.presenter.didTogglePushNotifications(isOn: isOn)
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectItem(items[indexPath.row])
    }
}

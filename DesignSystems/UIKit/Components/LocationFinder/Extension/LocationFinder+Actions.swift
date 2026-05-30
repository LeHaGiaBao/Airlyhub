//
//  LocationFinder+Actions.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 30/05/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

// MARK: - Actions
extension LocationFinder {
    @objc func searchTextChanged() {
        onSearchTextChanged?(searchContainerView.textField.text ?? "")
    }

    @objc func myLocationTapped() {
        animateOut {
            self.onSelectMyLocation?()
            self.dismiss(animated: false)
        }
    }

    @objc func dismissSheet() {
        searchContainerView.textField.resignFirstResponder()
        animateOut {
            self.onCancel?()
            self.dismiss(animated: false)
        }
    }
}

// MARK: - UITextFieldDelegate
extension LocationFinder: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITableViewDataSource & Delegate
extension LocationFinder: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.reuseID, for: indexPath) as! LocationCell
        cell.configure(with: results[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selected = results[indexPath.row]
        searchContainerView.textField.resignFirstResponder()
        animateOut {
            self.onConfirm?(selected)
            self.dismiss(animated: false)
        }
    }
}

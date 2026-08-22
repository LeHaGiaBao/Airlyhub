//
//  TourDetailViewProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol TourDetailViewProtocol: AnyObject {
    func showLoading(_ isLoading: Bool)
    /// Called both for the first load and after any selection change — the
    /// presenter always hands over a complete view model, never a partial patch.
    func render(_ viewModel: TourDetailViewModel)
    func showError(_ message: String)
}

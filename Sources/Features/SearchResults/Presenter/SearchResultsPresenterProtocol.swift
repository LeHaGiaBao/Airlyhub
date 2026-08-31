//
//  SearchResultsPresenterProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol SearchResultsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapShowMore()
    func didTapFilter()
    func didSelectItem(id: String)
    func didToggleFavorite(id: String)
    func didTapBack()
}

//
//  SearchResultsRouterProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol SearchResultsRouterProtocol: AnyObject {
    func showTourDetail(id: String)
    func presentSearchFilter(criteria: SearchCriteria,
                             onApply: @escaping (SearchCriteria) -> Void)
    func dismiss()
}

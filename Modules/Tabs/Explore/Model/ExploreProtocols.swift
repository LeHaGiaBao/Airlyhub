//
//  ExploreProtocols.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import Foundation

protocol ExploreViewProtocol: AnyObject {
    func showTitle(_ title: String)
}

protocol ExplorePresenterProtocol {
    func viewDidLoad()
}

protocol ExploreInteractorProtocol {}

protocol ExploreRouterProtocol: AnyObject {}

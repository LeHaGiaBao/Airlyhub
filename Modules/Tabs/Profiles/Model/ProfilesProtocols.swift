//
//  ProfilesProtocols.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import Foundation

protocol ProfilesViewProtocol: AnyObject {
    func showTitle(_ title: String)
}

protocol ProfilesPresenterProtocol {
    func viewDidLoad()
}

protocol ProfilesInteractorProtocol {}

protocol ProfilesRouterProtocol: AnyObject {}

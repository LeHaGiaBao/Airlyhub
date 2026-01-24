//
//  FlightsProtocols.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import Foundation

protocol FlightsViewProtocol: AnyObject {
    func showTitle(_ title: String)
}

protocol FlightsPresenterProtocol {
    func viewDidLoad()
}

protocol FlightsInteractorProtocol {}

protocol FlightsRouterProtocol: AnyObject {}

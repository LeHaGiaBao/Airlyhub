//
//  TourDetailPresenterProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol TourDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapBack()
    func didToggleFavorite()
    func didSelectDuration(index: Int)
    func didSelectDepartureTime(index: Int)
    func didChangePassengers(_ count: Int)
    func didSelectDate(_ date: Date)
    func didTapAllReviews()
    func didTapBook()
}

//
//  MyTicketsPresenterProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import RxSwift

protocol MyTicketsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func getMyTickets() -> [MyTicketsSection]
    func navigateToTicketDetail(at indexPath: IndexPath) -> Observable<MyTicketDetailBuilderAction>
}

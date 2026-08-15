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
    func getMyTickets() -> [MyTicketsSection]
    /// Opens the tapped row. An index outside the list yields an empty signal
    /// rather than a crash — the table and the sections are read separately.
    func navigateToTicketDetail(at indexPath: IndexPath) -> Observable<MyTicketDetailBuilderAction>
}

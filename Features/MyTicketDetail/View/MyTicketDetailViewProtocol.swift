//
//  MyTicketDetailViewProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol MyTicketDetailViewProtocol: AnyObject {
    /// Fills the whole screen in one call — the record never changes while it is
    /// open, so there is nothing here to update piecemeal.
    func showTicket(_ ticket: TicketModel)
}

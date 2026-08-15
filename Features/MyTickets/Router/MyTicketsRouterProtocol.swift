//
//  MyTicketsRouterProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import RxSwift

protocol MyTicketsRouterProtocol: AnyObject {
    /// - Returns: a signal that completes when the detail screen is done, which is
    ///   also what pops it — the same contract `ProfilesRouter` uses for the
    ///   screens it pushes.
    func navigateToTicketDetail(ticket: TicketModel) -> Observable<MyTicketDetailBuilderAction>
}

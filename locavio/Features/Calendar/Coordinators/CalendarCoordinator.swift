//
//  CalendarCoordinator.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import Foundation
import SwiftUI

@Observable
final class CalendarCoordinator {
    var path = NavigationPath()
    
    func pushToTicketDetails(ticket: Ticket) {
        path.append(CalendarRoutes.ticketDetails(ticket: ticket))
    }
    
    func pushToEditTicket(ticket: Ticket) {
        path.append(CalendarRoutes.editTicket(ticket: ticket))
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}

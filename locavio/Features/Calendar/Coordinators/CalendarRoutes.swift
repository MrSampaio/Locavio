//
//  CalendarRoutes.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation

enum CalendarRoutes: Hashable {
    case ticketDetails(ticket: Ticket)
    case editTicket(ticket: Ticket)
}

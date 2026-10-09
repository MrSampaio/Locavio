//
//  TicketsRoutes.swift
//  locavio
//
//  Created by Julio Sampaio on 09/10/26.
//

import Foundation

#warning("TODO: Implementar rotas de tickets")


enum TicketsRoutes: Hashable {
    case ticketDetails(ticket: Ticket)
}
// rotas de sheets
enum TicketsSheet: String, Identifiable {
    case addTicket
    var id: String { self.rawValue }
}


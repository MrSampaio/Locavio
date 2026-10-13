//
//  PropertiesRoutes.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation
 
// rotas de empilhamento (NavigationStack)
enum PropertiesRoute: Hashable {
    case details(property: Property)
    case lastPayments(property: Property)
    case editProperty(property: Property)
    case editPropertyExpenses(property: Property)
    case ticketDetails(ticket: Ticket)
    case editTicket(ticket: Ticket)
}
 
// rotas de sheets
enum PropertiesSheet: String, Identifiable {
    case addProperty
    var id: String { self.rawValue }
}

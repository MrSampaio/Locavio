//
//  TicketModel.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftData

@Model
final class Ticket: Identifiable {
    var title: String?
    var ticketNumber: Int?
    var ticketDescription: String?
    var createdAt: Date?
    var conclusionDate: Date?

    @Relationship(deleteRule: .cascade, inverse: \Maintence.ticket)
    var maintence: Maintence?
    
    init(title: String? = nil, ticketNumber: Int? = nil, ticketDescription: String? = nil, createdAt: Date? = nil, conclusionDate: Date? = nil) {
        self.title = title
        self.ticketNumber = ticketNumber
        self.ticketDescription = ticketDescription
        self.createdAt = createdAt
        self.conclusionDate = conclusionDate
    }

}

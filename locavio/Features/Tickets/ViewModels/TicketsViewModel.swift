//
//  TicketsViewModel.swift
//  locavio
//
//  Created by Julio Sampaio on 08/10/26.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
final class TicketsViewModel {
    
    var title: String = ""
    var createdAt: Date = Date()
    var conclusionDate: Date = Date()
    var ticketDescription: String = ""
    var property: Property?
//    var maintence: [Maintence] = []
    
    func createTicket(context: ModelContext, title: String, createdAt: Date, conclusionDate: Date, ticketDescription: String, property: Property) throws {
        
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanDescription = ticketDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let newTicket = Ticket(
            title: cleanTitle,
            ticketNumber: 01,
            ticketDescription: cleanDescription,
            createdAt: createdAt,
            conclusionDate: conclusionDate,
            property: property
        )
        
        context.insert(newTicket)
        
        do {
            try context.save()
        } catch {
            print("Error when trying to save a new ticket: \(error)")
        }
    }
    
    
    
    
}

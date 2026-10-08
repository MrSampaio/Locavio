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
        
        let ticketNumber = try generateTicketNumber(context: context)
        
        let newTicket = Ticket(
            title: cleanTitle,
            ticketNumber: ticketNumber,
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
            throw TicketsError.savingError
        }
    }
    
    func deleteTicket(ticket: Ticket, context: ModelContext) {
        context.delete(ticket)
    }
    
    // gerar numero do chamado
    func generateTicketNumber(context: ModelContext) throws -> Int {
        
        // fetch de todos os chamados existentes
        var descriptor = FetchDescriptor<Ticket>(
            sortBy: [SortDescriptor(\.ticketNumber, order: .reverse)]
        )
        // traz apenas o primeiro resultado
        descriptor.fetchLimit = 1
        
        do {
            let latestTickets = try context.fetch(descriptor)
            
            // se encontrou algum chamado, pega o número dele e soma 1
            if let lastTicket = latestTickets.first {
                return (lastTicket.ticketNumber ?? 0) + 1
            } else {
                // se não tem nenhum chamado no banco, esse é o número 1
                return 1
            }
            
        } catch {
            print("Error when trying to fetch the latest ticket number: \(error)")
            throw TicketsError.generateTicketNumberError
        }
    }
    
    
    
    
}

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
    var searchText = ""
    var filter: TicketsFilter = .all
    var ticketTitle: String = ""
    var createdAt: Date = Date()
    var conclusionDate: Date = Date()
    var ticketDescription: String = ""
    var property: Property?
//    var maintence: [Maintence] = []
    
    var showDeleteAlert = false
    var showCloseAlert = false
    
    var isSelectionMode = false
    var selectedTickets: Set<Ticket> = []
    
    enum TicketSegment: CaseIterable {
        case all, open, closed
    }
    
    var isPresentedSheet: Bool = false
    
    func createTicket(context: ModelContext) throws {
        
        let cleanTitle = ticketTitle.trimmingCharacters(in: .whitespacesAndNewlines)
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
    
    func deleteSelectedTickets(context: ModelContext) {
        for ticket in selectedTickets {
            deleteTicket(ticket: ticket, context: context)
        }
        
        selectedTickets.removeAll()
        isSelectionMode = false
    }
    
    func toggleSelection(for ticket: Ticket) {
        if selectedTickets.contains(ticket) {
            selectedTickets.remove(ticket)
        } else {
            selectedTickets.insert(ticket)
        }
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
    
    
    func visibleTickets(from tickets: [Ticket]) -> [Ticket] {
        let bySegment = tickets.filter(matchesSegment)

        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return bySegment }

        return bySegment.filter { ticket in
            (ticket.title ?? "").localizedCaseInsensitiveContains(query)
            || (ticket.ticketDescription ?? "").localizedCaseInsensitiveContains(query)
        }
    }

    private func matchesSegment(_ ticket: Ticket) -> Bool {
        switch filter {
        case .all: return true
        case .open:   return (ticket.isConcluded != true)
        case .closed: return (ticket.isConcluded == true)
        }
    }
    
    
    
    
    
    
    
}

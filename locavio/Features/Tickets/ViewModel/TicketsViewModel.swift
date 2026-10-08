//
//  TicketsViewModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 07/10/26.
//

import SwiftUI
import Observation

@Observable
final class TicketsViewModel {
    var searchText = ""
    var filter: TicketsFilter = .all
    
    enum TicketSegment: CaseIterable {
        case all, open, closed
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
        case .open: return ticket.conclusionDate == nil
        case .noRented: return ticket.conclusionDate != nil
        }
    }
}
    


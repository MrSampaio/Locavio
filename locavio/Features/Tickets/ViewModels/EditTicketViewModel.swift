//
//  EditTicketViewModel.swift
//  locavio
//
//  Created by Julio Sampaio on 08/10/26.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
final class EditTicketViewModel {
    var title: String = ""
    var ticketDescription: String = ""
    var isConcluded: Bool = false
    
    // lista dinâmica que vai aparecer na tela
    var maintences: [MaintenceDraft] = []
    
    // carrega os dados do chamado
    func loadTicket(_ ticket: Ticket) {
        
        self.title = ticket.title ?? ""
        self.ticketDescription = ticket.ticketDescription ?? ""
        self.isConcluded = ticket.isConcluded ?? false
        
        // transforma as Maintences do banco em Rascunhos para a tela
        if let existingMaintences = ticket.maintence {
            self.maintences = existingMaintences.map {
                MaintenceDraft(item: $0.item ?? "", value: $0.value)
            }
        }
        
    }
    
    // função para adicionar campo de manutenção
    func addMaintenceField() {
        maintences.append(MaintenceDraft(item: "", value: nil))
    }
    
    // função para remover um campo de manutenção
    func removeMaintence(at index: Int) {
        maintences.remove(at: index)
    }
    
    // função para salvar as atualizações do chamado
    func saveChanges(ticket: Ticket, context: ModelContext) throws {
        
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanDescription = ticketDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // atualiza os dados básicos
        ticket.title = cleanTitle
        ticket.ticketDescription = cleanDescription
        
        // limpa as manutenções antigas do banco para evitar duplicatas ou lixo
        if let oldMaintences = ticket.maintence {
            for oldMaintence in oldMaintences {
                context.delete(oldMaintence)
            }
        }
        
        // cria as novas manutenções a partir da lista da tela
        var newMaintences: [Maintence] = []
        
        for draft in maintences {
            
            // só salva se o usuário tiver digitado o nome do item
            guard !draft.item.isEmpty else { continue }
            
            let newMaintence = Maintence(ticket: ticket, item: draft.item, value: draft.value)
            context.insert(newMaintence)
            newMaintences.append(newMaintence)
        }
        
        // atualiza o relacionamento
        ticket.maintence = newMaintences
        
        do {
            try context.save()
        } catch {
            print("Erro when trying to save ticket: \(error.localizedDescription)")
            throw TicketsError.editTicketError
        }
        
    }
}

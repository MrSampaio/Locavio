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
    var property: Property?
    var createdAt: Date = Date()
    var conclusionDate: Date = Date()
    var maintences: [MaintenceDraft] = []

    var totalMaintence: Double {
        maintences.reduce(0) { total, maintence in
            total + (maintence.value ?? 0)
        }
    }

    var formattedTotalMaintence: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")

        return formatter.string(
            from: NSNumber(value: totalMaintence)
        ) ?? "R$ 0,00"
    }

    // Carrega os dados do chamado
    func loadTicket(_ ticket: Ticket) {
        title = ticket.title ?? ""
        ticketDescription = ticket.ticketDescription ?? ""
        isConcluded = ticket.isConcluded ?? false
        property = ticket.property
        createdAt = ticket.createdAt ?? Date()
        conclusionDate = ticket.conclusionDate ?? Date()

        maintences = ticket.maintence?.map {
            MaintenceDraft(
                item: $0.item ?? "",
                value: $0.value
            )
        } ?? []
    }

    // Adiciona um campo de manutenção
    func addMaintenceField() {
        maintences.append(
            MaintenceDraft(item: "", value: nil)
        )
    }

    // Remove um campo de manutenção
    func removeMaintence(at index: Int) {
        guard maintences.indices.contains(index) else {
            return
        }

        maintences.remove(at: index)
    }

    // Salva as alterações do chamado
    func saveChanges(
        ticket: Ticket,
        context: ModelContext
    ) throws {
        ticket.title = title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        ticket.ticketDescription = ticketDescription.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        ticket.property = property
        ticket.createdAt = createdAt
        ticket.conclusionDate = conclusionDate

        if let oldMaintences = ticket.maintence {
            for oldMaintence in oldMaintences {
                context.delete(oldMaintence)
            }
        }

        var newMaintences: [Maintence] = []

        for draft in maintences {
            let cleanItem = draft.item.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

            guard !cleanItem.isEmpty else {
                continue
            }

            let newMaintence = Maintence(
                ticket: ticket,
                item: cleanItem,
                value: draft.value
            )

            context.insert(newMaintence)
            newMaintences.append(newMaintence)
        }

        ticket.maintence = newMaintences

        do {
            try context.save()
        } catch {
            print("Erro ao salvar chamado: \(error.localizedDescription)")
            throw TicketsError.editTicketError
        }
    }
}

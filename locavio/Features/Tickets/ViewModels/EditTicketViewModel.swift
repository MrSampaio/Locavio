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

    // calcula a soma dos valores de todas as manutenções
    var totalMaintence: Double {
        maintences.reduce(0) { total, maintence in
            total + (maintence.value ?? 0)
        }
    }

    // formata o total das manutenções em reais
    var formattedTotalMaintence: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")

        return formatter.string(
            from: NSNumber(value: totalMaintence)
        ) ?? "R$ 0,00"
    }

    // carrega os dados do chamado
    func loadTicket(_ ticket: Ticket) {

        self.title = ticket.title ?? ""
        self.ticketDescription = ticket.ticketDescription ?? ""
        self.isConcluded = ticket.isConcluded ?? false

        // transforma as Maintences do banco em Rascunhos para a tela
        if let existingMaintences = ticket.maintence {
            self.maintences = existingMaintences.map {
                MaintenceDraft(
                    item: $0.item ?? "",
                    value: $0.value
                )
            }
        } else {
            self.maintences = []
        }
    }

    // função para adicionar campo de manutenção
    func addMaintenceField() {
        maintences.append(
            MaintenceDraft(item: "", value: nil)
        )
    }

    // função para remover um campo de manutenção
    func removeMaintence(at index: Int) {
        guard maintences.indices.contains(index) else {
            return
        }

        maintences.remove(at: index)
    }

    // função para salvar as atualizações do chamado
    func saveChanges(ticket: Ticket, context: ModelContext) throws {

        let cleanTitle = title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        let cleanDescription = ticketDescription.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

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

            // limpa espaços em branco do nome do item
            let cleanItem = draft.item.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

            // só salva se o usuário tiver digitado o nome do item
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

        // atualiza o relacionamento
        ticket.maintence = newMaintences

        do {
            try context.save()
        } catch {
            print(
                "Erro ao salvar as alterações do chamado: \(error.localizedDescription)"
            )
            throw TicketsError.editTicketError
        }
    }
}

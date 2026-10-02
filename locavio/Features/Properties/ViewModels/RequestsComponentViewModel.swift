//
//  RequestsComponentViewModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 02/10/26.
//

import Foundation
import SwiftData
import Observation

/// Dados de um card de solicitação.
struct RequestsComponentViewModel: Identifiable {
    let id: PersistentIdentifier
    let title: String          // item(ns) da tabela Maintence
    let deadlineLabel: String  // "Resolver até"
    let deadlineText: String   // conclusionDate formatada
}

@Observable
final class MaintenanceRequestsViewModel {
    private let property: Property

    init(property: Property) {
        self.property = property
    }

    var deadlineLabel: String { "Resolver até" }
    var emptyText: String { "Nenhuma solicitação" }

    /// Um card por chamado (Ticket) do imóvel, do prazo mais próximo
    /// para o mais distante. Chamados sem data ficam no fim.
    var cards: [RequestsComponentViewModel] {
        (property.tickets ?? [])
            .sorted { ($0.conclusionDate ?? .distantFuture) < ($1.conclusionDate ?? .distantFuture) }
            .map { ticket in
                RequestsComponentViewModel(
                    id: ticket.persistentModelID,
                    title: title(for: ticket),
                    deadlineLabel: deadlineLabel,
                    deadlineText: deadlineText(for: ticket)
                )
            }
    }

    var isEmpty: Bool { (property.tickets ?? []).isEmpty }

    // MARK: - Helpers

    /// Itens da tabela Maintence do chamado (ex.: "Trocar Torneira").
    /// Com mais de um item, eles são separados por vírgula.
    /// Sem itens, usa o título do chamado.
    private func title(for ticket: Ticket) -> String {
        let items = (ticket.maintence ?? [])
            .compactMap { $0.item?.trimmedOrNil }

        if !items.isEmpty { return items.joined(separator: ", ") }

        return ticket.title?.trimmedOrNil ?? "Sem item"
    }

    private func deadlineText(for ticket: Ticket) -> String {
        guard let date = ticket.conclusionDate else { return "Sem prazo" }
        return Self.dateFormatter.string(from: date)
    }

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "pt_BR")
        f.dateFormat = "dd/MM/yyyy"
        return f
    }()
}

private extension String {
    var trimmedOrNil: String? {
        let t = trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? nil : t
    }
}

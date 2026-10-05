//
//  RecentPaymentsViewModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 05/10/26.
//

import Foundation
import SwiftData
import Observation

struct PaymentRow: Identifiable {
    let id: PersistentIdentifier
    let monthText: String      // "Fevereiro, 2026"
    let hasProof: Bool
}

/// Comprovante (PDF) que será mostrado ao tocar no ícone de info.
struct ProofItem: Identifiable {
    let id: PersistentIdentifier
    let monthText: String
    let data: Data
}

@Observable
final class RecentPaymentsViewModel {
    private let property: Property

    /// Quando preenchido, a tela abre o comprovante.
    var proofToShow: ProofItem?

    init(property: Property) {
        self.property = property
    }

    var screenTitle: String { "Últimos pagamentos" }
    var emptyText: String { "Nenhum pagamento registrado" }

    var isEmpty: Bool { (property.payments ?? []).isEmpty }

    /// Pagamentos do imóvel, do mais recente para o mais antigo.
    private var sortedPayments: [Payment] {
        (property.payments ?? [])
            .sorted { ($0.date ?? .distantPast) > ($1.date ?? .distantPast) }
    }

    var rows: [PaymentRow] {
        sortedPayments.map { payment in
            PaymentRow(
                id: payment.persistentModelID,
                monthText: Self.monthText(for: payment.date),
                hasProof: payment.proof != nil
            )
        }
    }

    // MARK: - Comprovante

    func showProof(for id: PersistentIdentifier) {
        guard let payment = sortedPayments.first(where: { $0.persistentModelID == id }),
              let data = payment.proof else { return }

        proofToShow = ProofItem(
            id: id,
            monthText: Self.monthText(for: payment.date),
            data: data
        )
    }

    // Formatação

    /// Só mês e ano. Ex.: "Fevereiro, 2026"
    private static func monthText(for date: Date?) -> String {
        guard let date else { return "—" }
        let text = monthFormatter.string(from: date)
        return text.prefix(1).uppercased() + text.dropFirst()
    }

    private static let monthFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "pt_BR")
        f.dateFormat = "LLLL, yyyy"
        return f
    }()
}

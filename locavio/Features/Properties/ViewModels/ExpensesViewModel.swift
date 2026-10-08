//
//  ExpensesViewModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 01/10/26.
//

import Foundation
import SwiftData
import Observation

struct ExpenseRow: Identifiable {
    let id: PersistentIdentifier
    let title: String
    let valueText: String
}

@Observable
final class ExpensesViewModel {
    
    var property: Property = Property()
    var isExpanded = true
    var newTitle = ""
    var newValueText = ""

    var totalLabel: String { "Valor total" }
    var emptyText: String { "Nenhuma despesa adicionada" }

    var rows: [ExpenseRow] {
        (property.expenses ?? []).map { expense in
            ExpenseRow(
                id: expense.persistentModelID,
                title: expense.title?.trimmedOrNil ?? "Sem título",
                valueText: Self.format(expense.value ?? 0)
            )
        }
    }

    ///Soma de todas as despesas do imóvel
    var totalExpenses: Double {
        (property.expenses ?? []).reduce(0) { $0 + ($1.value ?? 0) }
    }

    //Adicionar / remover

    var canAdd: Bool {
        newTitle.trimmedOrNil != nil && parsedNewValue != nil
    }

    func toggle() { isExpanded.toggle() }

    func addExpense(in context: ModelContext) {
        guard let title = newTitle.trimmedOrNil, let value = parsedNewValue else { return }

        let expense = Expenses(property: property, title: title, value: value, date: Date())
        
        context.insert(expense)
        try? context.save()

        newTitle = ""
        newValueText = ""
    }

    func delete(_ id: PersistentIdentifier, in context: ModelContext) {
        guard let expense = property.expenses?.first(where: { $0.persistentModelID == id }) else { return }
        
        property.expenses?.removeAll { $0.persistentModelID == id }
        context.delete(expense)
        try? context.save()
    }

    

    /// Aceita "200", "200,50", "200.50" e "1.200,50".
    private var parsedNewValue: Double? {
        var text = newValueText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return nil }

        if text.contains(",") {
            text = text.replacingOccurrences(of: ".", with: "")
                       .replacingOccurrences(of: ",", with: ".")
        }

        guard let value = Double(text), value >= 0 else { return nil }
        return value
    }

    private static func format(_ value: Double) -> String {
        value.formatted(.currency(code: "BRL").locale(Locale(identifier: "pt_BR")))
    }
}

private extension String {
    var trimmedOrNil: String? {
        let t = trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? nil : t
    }
}

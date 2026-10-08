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
    let expense: Expenses
}

@Observable
final class ExpensesViewModel {
    
    enum Storage {
        case persisted(Property)
        case draft
    }
    
    private let storage: Storage
    var expenses: [Expenses]
    var isExpanded = false
    var newTitle = ""
    var newValueText = ""
    
    init(property: Property) {
        storage = .persisted(property)
        expenses = property.expenses ?? []
    }
    
    init() {
        storage = .draft
        expenses = []
    }
    
    var totalLabel: String { "Valor total" }
    var emptyText: String { "Nenhuma despesa adicionada" }
    
    var rows: [ExpenseRow] {
        expenses.map { expense in
            ExpenseRow(
                id: expense.persistentModelID,
                title: expense.title?.trimmedOrNil ?? "Sem título",
                valueText: Self.format(expense.value ?? 0),
                expense: expense
            )
        }
    }
    
    ///Soma de todas as despesas do imóvel
    var totalExpenses: Double {
        expenses.reduce(0) { $0 + ($1.value ?? 0) }
    }
    
    //Adicionar / remover
    
    var canAdd: Bool {
        newTitle.trimmedOrNil != nil && parsedNewValue != nil
    }
    
    func toggle() { isExpanded.toggle() }
    
    func addExpense(context: ModelContext) {
        
        guard let title = newTitle.trimmedOrNil, let value = parsedNewValue else { return }
        
        switch storage {
        case .persisted(let property):
            let expense = Expenses(property: property, title: title, value: value, date: Date())
            context.insert(expense)
            save(context)
            expenses.append(expense)
        case .draft:
            expenses.append(Expenses(title: title, value: value, date: Date()))
        }
        
        newTitle = ""
        newValueText = ""
    }
    
    func delete(_ expense: Expenses, context: ModelContext) {
        expenses.removeAll { $0 == expense }
        
        if case .persisted(let property) = storage {
            property.expenses?.removeAll { $0 == expense }
            context.delete(expense)
            save(context)
        }
    }
    
    private func save(_ context: ModelContext) {
        do { try context.save() }
        catch { print("Erro ao salvar despesas: \(error)") }
    }
    
    /// Chamar quando o imóvel for salvo, para persistir as despesas do rascunho
    func assignPropertyToExpense(to property: Property, context: ModelContext) {
        guard case .draft = storage else { return }

        for expense in expenses {
            expense.property = property
            context.insert(expense)
        }
        
        save(context)
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

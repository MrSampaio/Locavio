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
    let id = UUID()
    let title: String
    let valueText: String
    let expense: Expenses?
}

@Observable
final class ExpensesViewModel {
    
    enum Storage {
        case persisted(Property)
        case draft
    }
    
    private let storage: Storage
    
    /// Despesas e lucro do rascunho. Só são usados quando `storage == .draft`.
    private var draftExpenses: [Expenses] = []
    private var draftProfit = 0.0
    
    var isExpanded = false
    var newTitle = ""
    var newValueText = ""
    var errorMessage = ""
    var showErrorAlert = false
    
    init(property: Property) {
        storage = .persisted(property)
    }
    
    init() {
        storage = .draft
    }
    
    /// Despesas exibidas.
    /// - `persisted`: lê direto do imóvel, então qualquer mudança nele (ex.: edição) aparece na hora.
    ///   Antes o view model tirava uma "foto" da lista no init e ficava desatualizado.
    /// - `draft`: lista local, usada enquanto o imóvel ainda não foi salvo (ou na edição, como cópia).
    var expenses: [Expenses] {
        get {
            switch storage {
            case .persisted(let property):
                return (property.expenses ?? []).sorted {
                    ($0.date ?? .distantPast) < ($1.date ?? .distantPast)
                }
            case .draft:
                return draftExpenses
            }
        }
        set {
            // o imóvel salvo é a fonte da verdade: só o rascunho aceita atribuição direta
            if case .draft = storage {
                draftExpenses = newValue
            }
        }
    }
    
    /// Lucro do imóvel (lido ao vivo quando persistido).
    var profit: Double {
        get {
            switch storage {
            case .persisted(let property):
                return property.profit ?? 0
            case .draft:
                return draftProfit
            }
        }
        set {
            if case .draft = storage {
                draftProfit = newValue
            }
        }
    }
    
    var totalLabel: String { String(localized: "Valor total") }
    var emptyText: String { String(localized: "Nenhuma despesa adicionada") }
    
    var rows: [ExpenseRow] {
        expenses.map { expense in
            ExpenseRow(
                title: expense.title?.trimmedOrNil ?? String(localized: "Sem título"),
                valueText: Self.format(expense.value ?? 0),
                expense: expense
            )
        }
    }
    
    var profitRow: ExpenseRow {
        ExpenseRow(title: String(localized: "Lucro"), valueText: Self.format(profit), expense: nil)
    }
    
    ///Soma de todas as despesas do imóvel
    var totalExpenses: Double {
        expenses.reduce(0) { $0 + ($1.value ?? 0) }
    }
    
    var totalRentValue: Double {
        totalExpenses + profit
    }
    
    //Adicionar / remover
    
    var canAdd: Bool {
        newTitle.trimmedOrNil != nil && parsedNewValue != nil
    }
    
    func toggle() { isExpanded.toggle() }
    
    func addExpense(context: ModelContext) throws {
        
        guard let title = newTitle.trimmedOrNil else { return }
        
        guard hasOnlyNumbers(newValueText) else { throw ExpensesErrors.invalidValue }
        
        guard let value = parsedNewValue else { return }
        
        switch storage {
        case .persisted(let property):
            // o relacionamento inverso (expense.property) já coloca a despesa na lista do imóvel
            let expense = Expenses(property: property, title: title, value: value, date: Date())
            context.insert(expense)
            save(context)
        case .draft:
            draftExpenses.append(Expenses(title: title, value: value, date: Date()))
        }
        
        newTitle = ""
        newValueText = ""
    }
    
    func hasOnlyNumbers(_ text: String) -> Bool {
        let withoutCurrency = text
            .replacingOccurrences(of: "R$", with: "")
            .filter { !$0.isWhitespace }
        
        return withoutCurrency.allSatisfy { $0.isNumber || $0 == "," || $0 == "." }
    }
    
    func delete(_ expense: Expenses, context: ModelContext) {
        switch storage {
        case .persisted(let property):
            property.expenses?.removeAll { $0 == expense }
            context.delete(expense)
            save(context)
        case .draft:
            draftExpenses.removeAll { $0 == expense }
        }
    }
    
    private func save(_ context: ModelContext) {
        do { try context.save() }
        catch { print("Erro ao salvar despesas: \(error)") }
    }
    
    /// Chamar quando o imóvel for salvo, para persistir as despesas do rascunho
    func assignPropertyToExpense(to property: Property, context: ModelContext) {
        guard case .draft = storage else { return }

        for expense in draftExpenses {
            expense.property = property
            context.insert(expense)
        }
        
        save(context)
    }
    
    
    /// Aceita "200", "200,50", "200.50" e "1.200,50".
    private var parsedNewValue: Double? {
        newValueText = formatAsDouble(textToFormat: newValueText)
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
    
    func formatAsDouble(textToFormat: String) -> String {
        let cleaned = textToFormat.replacingOccurrences(of: ".", with: "")
        return cleaned.filter { $0.isNumber || $0 == "," }
    }
}

private extension String {
    var trimmedOrNil: String? {
        let t = trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? nil : t
    }
}

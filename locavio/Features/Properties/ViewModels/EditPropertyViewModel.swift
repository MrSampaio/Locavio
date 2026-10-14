//
//  EditPropertyViewModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 13/10/26.
//


import Foundation
import Observation
import SwiftData


@Observable
final class EditPropertyViewModel {

    let property: Property


    let expensesViewModel = ExpensesViewModel()

    var propertyType: PropertyType
    var uf: UF

    var isLoaded = false
    var showErrorAlert = false
    var errorMessage = ""

    init(property: Property) {
        self.property = property
        propertyType = property.type ?? .other
        uf = UF(rawValue: property.uf ?? "") ?? .insert
    }

    /// Carrega o imóvel no draft e as despesas na lista da tela. Roda uma vez só:
    /// a tela pode reaparecer e não pode perder o que foi editado.
    func load(using form: PropertiesViewModel) {
        guard !isLoaded else { return }

        form.loadDraft(from: property)
        form.resetValidation()

        expensesViewModel.expenses = (property.expenses ?? []).map {
            Expenses(title: $0.title ?? "", value: $0.value ?? 0, date: $0.date ?? .now)
        }

        isLoaded = true
    }

    /// Valida e grava. Devolve `true` se salvou (a view decide fechar a tela).
    func save(using form: PropertiesViewModel, context: ModelContext) -> Bool {
        guard form.validateForm() else {
            present("Corrija os campos destacados em vermelho.")
            return false
        }

        do {
            return try form.applyDraft(
                to: property,
                context: context,
                type: propertyType,
                uf: uf,
                expenses: expensesViewModel.expenses
            )
        } catch {
            show(error)
            return false
        }
    }

    func show(_ error: Error) {
        present(error.localizedDescription)
    }

    private func present(_ message: String) {
        errorMessage = message
        showErrorAlert = true
    }
}

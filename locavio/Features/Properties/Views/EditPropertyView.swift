//
//  EditPropertyView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 12/10/26.
//

import SwiftUI
import SwiftData

struct EditPropertyView: View {

    let property: Property

    @Environment(\.dismiss) private var dismiss
    @Environment(PropertiesViewModel.self) private var viewModel
    @Environment(\.modelContext) private var context

    @State private var expensesViewModel = ExpensesViewModel()
    @State private var propertyType: PropertyType
    @State private var uf: UF
    @State private var isLoaded = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""

    init(property: Property) {
        self.property = property
        _propertyType = State(initialValue: property.type ?? .other)
        _uf = State(initialValue: UF(rawValue: property.uf ?? "") ?? .insert)
    }

    var body: some View {
        Form {
            // as seções só são criadas depois que o draft foi carregado:
            // assim os campos já nascem preenchidos
            if isLoaded {
                PropertyPhotoSection()
                PropertyInfoSection(propertyType: $propertyType)
                PropertyAddressSection(uf: $uf, onError: show)

                PropertyFinancialSection(expensesTotal: expensesViewModel.totalExpenses) {
                    ExpensesTextFieldCard(viewModel: expensesViewModel)
                }

                PropertyTenantSection()
                PropertyContractSection(onError: show)
            }
        }
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            #if canImport(UIKit)
                hideKeyboard()
            #endif
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Editar Imóvel")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    save()
                } label: {
                    Image(systemName: "checkmark")
                }
                .buttonStyle(.borderedProminent)
                .disabled(!isLoaded)
            }
        }
        .alert("Atenção!", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .onAppear { load() }
    }

    // Ações

    private func load() {
        guard !isLoaded else { return }

        viewModel.loadDraft(from: property)
        viewModel.resetValidation()

        // a lista de despesas da tela é uma CÓPIA das despesas do imóvel:
        // se o usuário voltar sem salvar, nada do que ele mexeu foi gravado
        expensesViewModel.expenses = (property.expenses ?? []).map {
            Expenses(title: $0.title ?? "", value: $0.value ?? 0, date: $0.date ?? .now)
        }

        isLoaded = true
    }

    private func save() {
        guard viewModel.validateForm() else {
            errorMessage = "Corrija os campos destacados em vermelho."
            showErrorAlert = true
            return
        }

        do {
            let saved = try viewModel.applyDraft(
                to: property,
                context: context,
                type: propertyType,
                uf: uf,
                expenses: expensesViewModel.expenses
            )
            if saved { dismiss() }
        } catch {
            show(error)
        }
    }

    private func show(_ error: Error) {
        errorMessage = error.localizedDescription
        showErrorAlert = true
    }
}



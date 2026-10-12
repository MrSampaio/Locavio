//
//  EditPropertyView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 12/10/26.
//

import SwiftUI


import SwiftData

/// Editar imóvel (tela empurrada no NavigationStack, com o botão de voltar do sistema).
struct EditPropertyView: View {

    let property: Property
    /// Abre a tela de despesas do imóvel (linha "Valor das despesas")
    var onEditExpenses: () -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(PropertiesViewModel.self) private var viewModel
    @Environment(\.modelContext) private var context

    @State private var propertyType: PropertyType
    @State private var uf: UF
    @State private var isLoaded = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""

    init(property: Property, onEditExpenses: @escaping () -> Void = {}) {
        self.property = property
        self.onEditExpenses = onEditExpenses
        _propertyType = State(initialValue: property.type ?? .other)
        _uf = State(initialValue: UF(rawValue: property.uf ?? "") ?? .insert)
    }

    private var expensesTotal: Double {
        (property.expenses ?? []).reduce(0) { $0 + ($1.value ?? 0) }
    }

    var body: some View {
        Form {
            // as seções só são criadas depois que o draft foi carregado:
            // assim os campos já nascem preenchidos
            if isLoaded {
                PropertyPhotoSection()
                PropertyInfoSection(propertyType: $propertyType)
                PropertyAddressSection(uf: $uf, onError: show)

                PropertyFinancialSection(expensesTotal: expensesTotal) {
                    expensesRow
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

    // Linha de despesas 

    private var expensesRow: some View {
        Button(action: onEditExpenses) {
            HStack {
                Label {
                    Text("Valor das despesas")
                } icon: {
                    Image(systemName: "creditcard")
                        .font(.subheadline)
                        .foregroundStyle(.accent)
                }

                Spacer()

                Text(expensesTotal, format: .currency(code: "BRL"))
                    .foregroundStyle(.secondary)

                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
        }
        .buttonStyle(.plain)
    }

    // Ações

    private func load() {
        // só uma vez: a tela reaparece ao voltar de outra (ex.: despesas) e não pode perder o que foi editado
        guard !isLoaded else { return }
        viewModel.loadDraft(from: property)
        viewModel.resetValidation()
        isLoaded = true
    }

    private func save() {
        guard viewModel.validateForm() else {
            errorMessage = "Corrija os campos destacados em vermelho."
            showErrorAlert = true
            return
        }

        do {
            if try viewModel.applyDraft(to: property, context: context, type: propertyType, uf: uf) {
                dismiss()
            }
        } catch {
            show(error)
        }
    }

    private func show(_ error: Error) {
        errorMessage = error.localizedDescription
        showErrorAlert = true
    }
}

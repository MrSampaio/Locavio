//
//  NewPropertyView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//


import SwiftUI
import SwiftData
import TipKit

/// Adicionar imóvel (apresentada como sheet).
struct NewPropertySheet: View {

    @Query private var owner: [Owner]

    @Environment(\.dismiss) private var dismiss
    @Environment(PropertiesViewModel.self) private var viewModel
    @Environment(\.modelContext) private var context

    @State private var expensesViewModel = ExpensesViewModel()
    @State private var propertyType: PropertyType = .other
    @State private var uf: UF = .insert
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var didStart = false

    private let photoTip = PropertyPhotoTip()

    var body: some View {
        NavigationStack {
            Form {
                PropertyPhotoSection(tip: photoTip)
                PropertyInfoSection(propertyType: $propertyType)
                PropertyAddressSection(uf: $uf, onError: show)

                PropertyFinancialSection(expensesTotal: expensesViewModel.totalExpenses) {
                    ExpensesTextFieldCard(viewModel: expensesViewModel)
                }

                PropertyTenantSection()
                PropertyContractSection(onError: show)
            }
            .ignoresSafeArea(.keyboard)
            .onTapGesture {
                #if canImport(UIKit)
                    hideKeyboard()
                #endif
            }
            .scrollDismissesKeyboard(.interactively)
            .alert("Atenção!", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                SheetsToolbar(onConfirm: {
                    save()
                }, onClose: {
                    viewModel.removeContractDraft()
                    dismiss()
                }, title: "Adicionar Imóvel")
            }
        }
        .onAppear {
            // só na primeira vez: o onAppear pode disparar de novo (ex.: ao fechar o preview do contrato)
            guard !didStart else { return }
            didStart = true
            viewModel.resetDraft()
            viewModel.resetValidation()
        }
    }

    private func save() {
        guard viewModel.validateForm() else {
            errorMessage = "Corrija os campos destacados em vermelho."
            showErrorAlert = true
            return
        }

        do {
            let saved = try viewModel.addProperty(
                context: context,
                type: propertyType,
                uf: uf,
                expenses: expensesViewModel.expenses,
                owner: owner.first ?? nil
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

#Preview {
    NewPropertySheet()
        .environment(PropertiesViewModel())
        .environment(ExpensesViewModel())
}

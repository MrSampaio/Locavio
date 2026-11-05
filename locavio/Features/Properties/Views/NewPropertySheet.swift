//
//  NewPropertyView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//


import SwiftUI
import SwiftData
import TipKit


struct NewPropertySheet: View {
    
    // o Owner agora vem do AppleAuthManager (usuário logado, com duplicados já juntados),
    // em vez de pegar o primeiro Owner qualquer do banco
    @Environment(AppleAuthManager.self) private var authManager
    
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
            .scrollDismissesKeyboard(.interactively)
            .dismissKeyboardOnTap()
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
            errorMessage = String(localized: "Corrija os campos destacados em vermelho.")
            showErrorAlert = true
            return
        }
        
        do {
            let saved = try viewModel.addProperty(
                context: context,
                type: propertyType,
                uf: uf,
                expenses: expensesViewModel.expenses,
                owner: authManager.currentOwner(context: context)
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
        .environment(AppleAuthManager())
}

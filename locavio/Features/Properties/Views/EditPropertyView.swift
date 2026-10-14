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
    var onEditExpenses: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @Environment(PropertiesViewModel.self) private var viewModel
    @Environment(\.modelContext) private var context
    
    @State private var propertyType: PropertyType
    @State private var uf: UF
    @State private var hasLoaded = false // Controle para carregar só na primeira vez
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
            PropertyPhotoSection()
            PropertyInfoSection(propertyType: $propertyType)
            PropertyAddressSection(uf: $uf, onError: show)
            
            PropertyFinancialSection(expensesTotal: expensesTotal) {
                expensesRow
            }
            
            PropertyTenantSection()
            PropertyContractSection(onError: show)
        }
        .dismissKeyboardOnTap()
        .scrollContentBackground(.hidden)
        .toolbar(.hidden, for: .tabBar)
        .ignoresSafeArea(edges: .bottom)
        .background(Color.appBg)
        .ignoresSafeArea(.keyboard)
        .scrollDismissesKeyboard(.interactively)
        .scrollIndicators(.hidden)
        .navigationTitle("Editar Imóvel")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    save()
                } label: {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.white)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .alert("Atenção!", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .onAppear {
            load()
        }
    }
    
    // Linha de despesas
    private var expensesRow: some View {
        Button {
            print("Botão de despesas clicado")
            onEditExpenses()
        } label: {
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
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    // Ações
    
    private func load() {
        guard !hasLoaded else { return }
        hasLoaded = true
        
        DispatchQueue.main.async {
            viewModel.loadDraft(from: property)
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

#Preview {
    @Previewable @State var viewModel = PropertiesViewModel()
    @Previewable @State var propertyType: PropertyType = .other

    let container = try! ModelContainer(
        for: Property.self,
        Tenant.self,
        Contract.self,
        Payment.self,
        Expenses.self,
        Ticket.self,
        Maintence.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    let property = Property()

    NavigationStack {
        EditPropertyView(property: property) {
            print("Editar despesas")
        }
        .environment(viewModel)
    }
    .modelContainer(container)
}

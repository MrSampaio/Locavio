//
//  EditPropertyView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 12/10/26.
//

import SwiftUI
import SwiftData

struct EditPropertyView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(PropertiesViewModel.self) private var propertiesViewModel

    @State private var viewModel: EditPropertyViewModel

    init(property: Property) {
        _viewModel = State(initialValue: EditPropertyViewModel(property: property))
    }

    var body: some View {
        Form {
            if viewModel.isLoaded {
                PropertyPhotoSection()
                PropertyInfoSection(propertyType: $viewModel.propertyType)
                PropertyAddressSection(uf: $viewModel.uf, onError: viewModel.show)

                PropertyFinancialSection(expensesTotal: viewModel.expensesViewModel.totalExpenses) {
                    ExpensesTextFieldCard(viewModel: viewModel.expensesViewModel)
                }

                PropertyTenantSection()
                PropertyContractSection(onError: viewModel.show)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color(.appBg).ignoresSafeArea())
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
                        .foregroundStyle(.white)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.isLoaded)
            }
        }
        .alert("Atenção!", isPresented: $viewModel.showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
        .onAppear { viewModel.load(using: propertiesViewModel) }
    }

    /// Fechar a tela é assunto da view (vem do ambiente); o view model só diz se salvou.
    private func save() {
        if viewModel.save(using: propertiesViewModel, context: context) {
            dismiss()
        }
    }
}


//
//  NewPropertyView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI
import SwiftData
import QuickLook
import UniformTypeIdentifiers

struct NewPropertySheet: View {
    
    @Query private var owner: [Owner]
    
    @Environment(\.dismiss) var dismiss
    @Environment(PropertiesViewModel.self) private var viewModel
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var context
    
    @State private var expensesViewModel = ExpensesViewModel()
    @State private var propertyType: PropertyType = .other
    @State private var paymentDay: Int = 1
    @State private var isImportingContract = false
    @State private var contractPreviewURL: URL?
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Informações do Imóvel") {
                    PropertyLabeledContent(textPropertyLabel: "Nome", iconPropertyLabel: "pencil.line", textFieldPlaceholder: "Ex: Casa 1", textFieldHasUnit: false, textFieldIsNumber: false, textFieldCharacterLimit: 20, textFieldType: .name)
                    
                    Picker(selection: $propertyType) {
                        ForEach(PropertyType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    } label: {
                        Label {
                            Text("Tipo")
                        } icon: {
                            Image(systemName: "house")
                                .font(.subheadline)
                                .foregroundStyle(.accent)
                        }
                    }
                    
                    PropertyLabeledContent(textPropertyLabel: "Área", iconPropertyLabel: "ruler", textFieldPlaceholder: "Ex: 32", textFieldHasUnit: true, textFieldUnit: "m²", textFieldIsNumber: true, textFieldType: .area)
                }
                
                Section("Endereço") {
                    PropertyLabeledContent(textPropertyLabel: "CEP", iconPropertyLabel: "mappin.and.ellipse", textFieldPlaceholder: "Ex: 12345-678", textFieldHasUnit: false, textFieldIsNumber: true, textFieldCharacterLimit: 9, textFieldType: .cep)
                    
                    PropertyLabeledContent(textPropertyLabel: "Rua", iconPropertyLabel: "location", textFieldPlaceholder: "Ex: Rua Ipê Amarelo", textFieldHasUnit: false, textFieldIsNumber: false, textFieldCharacterLimit: 47, textFieldType: .street)
                    
                    PropertyLabeledContent(textPropertyLabel: "Número", iconPropertyLabel: "numero.sign", textFieldPlaceholder: "Ex: 55", textFieldHasUnit: false, textFieldIsNumber: true, textFieldType: .number)
                    
                    PropertyLabeledContent(textPropertyLabel: "Bairro", iconPropertyLabel: "map", textFieldPlaceholder: "Ex: Santo Amaro", textFieldHasUnit: false, textFieldIsNumber: false, textFieldCharacterLimit: 32, textFieldType: .neighborhood)
                    
                    PropertyLabeledContent(textPropertyLabel: "Cidade", iconPropertyLabel: "building.2", textFieldPlaceholder: "Ex: São Paulo", textFieldHasUnit: false, textFieldIsNumber: false, textFieldCharacterLimit: 32, textFieldType: .city)
                    
                    PropertyLabeledContent(textPropertyLabel: "UF", iconPropertyLabel: "flag", textFieldPlaceholder: "Ex: SP", textFieldHasUnit: false, textFieldIsNumber: false, textFieldCharacterLimit: 2, textFieldType: .federalUnit)
                }
                
                Section {
                    ExpensesTextFieldCard(viewModel: expensesViewModel)
                    
                    PropertyLabeledContent(textPropertyLabel: "Lucro", iconPropertyLabel: "chart.line.uptrend.xyaxis", textFieldPlaceholder: "Insira um valor", textFieldHasUnit: false, textFieldIsNumber: true, textFieldType: .profit)
                    
                    Picker(selection: $paymentDay) {
                        ForEach(1..<32) { day in
                            Text(String(day)).tag(day)
                        }
                    } label: {
                        Label {
                            Text("Dia de Pagamento")
                        } icon: {
                            Image(systemName: "calendar")
                                .font(.subheadline)
                                .foregroundStyle(.accent)
                        }
                    }
                    .pickerStyle(.menu)
                } header: {
                    Text("Financeiro")
                } footer: {
                    HStack {
                        Text("Total do Aluguel")
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .font(.body)
                        
                        Spacer()
                        
                        Text(viewModel.calcTotalRent(totalValueExpenses: expensesViewModel.totalExpenses), format: .currency(code: "BRL"))
                            .font(.headline)
                            .foregroundStyle(.accent)
                    }
                    .padding(.vertical, 24)
                    .listRowInsets(EdgeInsets())
                }
                
                Section("Inquilino") {
                    PropertyLabeledContent(textPropertyLabel: "Nome", iconPropertyLabel: "person", textFieldPlaceholder: "Ex: Júlio Almeida Santos", textFieldHasUnit: false, textFieldIsNumber: false, textFieldCharacterLimit: 45, textFieldType: .tenantName)
                    
                    PropertyLabeledContent(textPropertyLabel: "Email", iconPropertyLabel: "envelope", textFieldPlaceholder: "Ex: email@email.com", textFieldHasUnit: false, textFieldIsNumber: false, textFieldCharacterLimit: 30, textFieldType: .tenantEmail)
                    
                    PropertyLabeledContent(textPropertyLabel: "CPF", iconPropertyLabel: "person.text.rectangle", textFieldPlaceholder: "Ex: 000.000.000-00", textFieldHasUnit: false, textFieldIsNumber: true, textFieldCharacterLimit: 14, textFieldType: .tenantCPF)
                    
                    PropertyLabeledContent(textPropertyLabel: "Telefone", iconPropertyLabel: "phone", textFieldPlaceholder: "Ex: (99) 99999-9999", textFieldHasUnit: false, textFieldIsNumber: true, textFieldCharacterLimit: 15, textFieldType: .tenantPhone)
                }
                
                Section("Contrato") {
                    ContractComponent(
                        contractName: viewModel.contractDraft?.title,
                        attachmentDate: viewModel.contractDraft?.createdAt) {
                            if viewModel.contractDraft == nil {
                                isImportingContract = true
                            } else {
                                viewModel.removeContractDraft()
                            }
                        } onOpen: {
                            contractPreviewURL = viewModel.makeContractPreviewURL()
                        }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .fileImporter(isPresented: $isImportingContract, allowedContentTypes: [.pdf]) { result in
                switch result {
                case .success(let url):
                    do {
                        try viewModel.importContract(from: url)
                    } catch {
                        show(error)
                    }
                case .failure(let failure):
                    show(failure)
                }
            }
            .quickLookPreview($contractPreviewURL)
            .alert("Atenção!", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                SheetsToolbar(onConfirm: {
                    saveProperty()
                }, onClose: {
                    viewModel.removeContractDraft()
                    dismiss()
                }, title: "Adicionar Imóvel")
            }
        }
    }
    
    private func saveProperty() {
        do {
            let saved = try viewModel.addProperty(
                context: context,
                image: nil,
                type: propertyType,
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

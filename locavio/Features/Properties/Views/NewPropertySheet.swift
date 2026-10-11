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
import PhotosUI
 
struct NewPropertySheet: View {
    
    @Query private var owner: [Owner]
    
    @Environment(\.dismiss) var dismiss
    @Environment(PropertiesViewModel.self) private var viewModel
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var context
    
    @State private var expensesViewModel = ExpensesViewModel()
    @State private var selectedImage: PhotosPickerItem?
    @State private var propertyType: PropertyType = .other
    @State private var uf: UF = .insert
    @State private var paymentDay: Int = 1
    @State private var isImportingContract = false
    @State private var contractPreviewURL: URL?
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        
        let propertyImage = viewModel.propertyDraft.image
        
        NavigationStack {
            
            Form {
                
                PhotosPicker(selection: $selectedImage, matching: .images) {
                    VStack {
                        if let image = propertyImage, let uiImage = UIImage(data: image) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 175)
                        } else {
                            VStack {
                                Text("Adicionar Foto do Imóvel")
                                    .foregroundStyle(.black)
                                    .bold()
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 175)
                            .background(.white)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "camera.fill")
                            .font(.subheadline)
                            .padding(15)
                            .foregroundStyle(.white)
                            .background(.imageFieldCameraInput)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(.systemGroupedBackground), lineWidth: 3))
                            .offset(x: 10, y: 10)
                    }
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
                .buttonStyle(.plain)
                .onChange(of: selectedImage) { _, newImage in
                    Task {
                        let data = await viewModel.loadImage(from: newImage)
                        viewModel.propertyDraft.image = data
                    }
                }
                
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
                    
                    Picker(selection: $uf) {
                        ForEach(UF.allCases) { uf in
                            Text(uf.rawValue).tag(uf)
                        }
                    } label: {
                        Label {
                            Text("UF")
                        } icon: {
                            Image(systemName: "flag")
                                .font(.subheadline)
                                .foregroundStyle(.accent)
                        }
                    }
                    
                    PropertyLabeledContent(textPropertyLabel: "Complemento", iconPropertyLabel: "door.left.hand.closed", textFieldPlaceholder: "Ex: Apartamento 21", textFieldHasUnit: false, textFieldIsNumber: false, textFieldType: .complement)
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
            // ViaCEP: quando o CEP (já com máscara) completa 8 dígitos, busca o endereço
            .onChange(of: viewModel.propertyDraft.cep) { _, newValue in
                guard newValue.onlyDigits.count == 8 else { return }
                Task { await lookupCEP(newValue) }
            }
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
    
    // ViaCEP: busca o endereço e preenche rua, bairro, cidade e UF
    private func lookupCEP(_ cep: String) async {
        do {
            let address = try await ViaCEPService.fetchAdress(cep: cep)
            // se o usuário mudou o CEP durante a requisição, descarta a resposta antiga
            guard viewModel.propertyDraft.cep.onlyDigits == cep.onlyDigits else { return }
            viewModel.fillAddress(from: address)
            if let code = address.uf, let found = UF(rawValue: code) {
                uf = found
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
    NewPropertySheet()
        .environment(PropertiesViewModel())
        .environment(ExpensesViewModel())
}

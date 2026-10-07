//
//  NewPropertyView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI

struct NewPropertySheet: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(PropertiesViewModel.self) private var viewModel
    @Environment(PropertiesCoordinator.self) private var coordinator
    
    @State private var propertyType: PropertyType = .other
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Informações do Imóvel") {
                    PropertyLabeledContent(textPropertyLabel: "Nome do Imóvel", iconPropertyLabel: "pencil.line", textFieldPlaceholder: "Ex: Casa 1", textFieldHasUnit: false, textFieldIsNumber: false, textFieldCharacterLimit: 20, textFieldType: .name)
                    
                    Picker(selection: $propertyType) {
                        ForEach(PropertyType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    } label: {
                        Label {
                            Text("Tipo de Imóvel")
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
                    
                    PropertyLabeledContent(textPropertyLabel: "Número do Imóvel", iconPropertyLabel: "numero.sign", textFieldPlaceholder: "Ex: 55", textFieldHasUnit: false, textFieldIsNumber: true, textFieldType: .number)
                    
                    PropertyLabeledContent(textPropertyLabel: "Bairro", iconPropertyLabel: "map", textFieldPlaceholder: "Ex: Santo Amaro", textFieldHasUnit: false, textFieldIsNumber: false, textFieldCharacterLimit: 32, textFieldType: .neighborhood)
                    
                    PropertyLabeledContent(textPropertyLabel: "Cidade", iconPropertyLabel: "building.2", textFieldPlaceholder: "Ex: São Paulo", textFieldHasUnit: false, textFieldIsNumber: false, textFieldCharacterLimit: 32, textFieldType: .city)
                    
                    PropertyLabeledContent(textPropertyLabel: "UF", iconPropertyLabel: "flag", textFieldPlaceholder: "Ex: SP", textFieldHasUnit: false, textFieldIsNumber: false, textFieldCharacterLimit: 2, textFieldType: .federalUnit)
                }
                
                Section("Inquilino") {
                    PropertyLabeledContent(textPropertyLabel: "Nome", iconPropertyLabel: "person", textFieldPlaceholder: "Ex: Júlio", textFieldHasUnit: false, textFieldIsNumber: false, textFieldCharacterLimit: 45, textFieldType: .tenantName)
                    
                    PropertyLabeledContent(textPropertyLabel: "Email", iconPropertyLabel: "envelope", textFieldPlaceholder: "Ex: email@email.com", textFieldHasUnit: false, textFieldIsNumber: false, textFieldCharacterLimit: 30, textFieldType: .tenantEmail)
                    
                    PropertyLabeledContent(textPropertyLabel: "CPF", iconPropertyLabel: "person.text.rectangle", textFieldPlaceholder: "Ex: 000.000.000-00", textFieldHasUnit: false, textFieldIsNumber: true, textFieldCharacterLimit: 14, textFieldType: .tenantCPF)
                    
                    PropertyLabeledContent(textPropertyLabel: "Telefone", iconPropertyLabel: "phone", textFieldPlaceholder: "Ex: (99) 99999-9999", textFieldHasUnit: false, textFieldIsNumber: true, textFieldCharacterLimit: 15, textFieldType: .tenantPhone)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .toolbar {
                SheetsToolbar(onConfirm: {
                    
                }, onClose: {
                    dismiss()
                }, title: "Adicionar Imóvel")
            }
        }
    }
}

#Preview {
    NewPropertySheet()
        .environment(PropertiesViewModel())
        .environment(PropertiesCoordinator())
}

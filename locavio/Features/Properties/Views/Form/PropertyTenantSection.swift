//
//  PropertyTenantSection.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 12/10/26.
//

import SwiftUI

struct PropertyTenantSection: View {
    
    @Environment(PropertiesViewModel.self) private var propertiesViewModel
    
    @State private var showAlert = false
    
    var body: some View {
        Section {
            PropertyLabeledContent(textPropertyLabel: "Nome", iconPropertyLabel: "person", textFieldPlaceholder: "Ex: Júlio Almeida Santos", textFieldHasUnit: false, textFieldIsNumber: false, textFieldCharacterLimit: 45, textFieldType: .tenantName)
            
            PropertyLabeledContent(textPropertyLabel: "Email", iconPropertyLabel: "envelope", textFieldPlaceholder: "Ex: email@email.com", textFieldHasUnit: false, textFieldIsNumber: false, textFieldCharacterLimit: 30, textFieldType: .tenantEmail)
            
            PropertyLabeledContent(textPropertyLabel: "CPF", iconPropertyLabel: "person.text.rectangle", textFieldPlaceholder: "Ex: 000.000.000-00", textFieldHasUnit: false, textFieldIsNumber: true, textFieldCharacterLimit: 14, textFieldType: .tenantCPF)
            
            PropertyLabeledContent(textPropertyLabel: "Telefone", iconPropertyLabel: "phone", textFieldPlaceholder: "Ex: (99) 99999-9999", textFieldHasUnit: false, textFieldIsNumber: true, textFieldCharacterLimit: 15, textFieldType: .tenantPhone)
        } header: {
            HStack {
                Text("Inquilino")
                
                Spacer()
                
                Button {
                    showAlert = true
                } label: {
                    Text("Excluir")
                        .foregroundStyle(Color.primary)
                        .font(.subheadline)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .glassEffect(.regular, in: Capsule())
                }
                .buttonStyle(.plain)
                .alert("Atenção!", isPresented: $showAlert) {
                    Button("Cancelar", role: .cancel) {}
                    Button("Excluir Inquilino", role: .destructive) {
                        propertiesViewModel.deleteTenant()
                    }
                } message: {
                    Text("Você realmente deseja excluir o inquilino da propriedade? Essa ação não poderá ser desfeita.")
                }
            }
        }
    }
}

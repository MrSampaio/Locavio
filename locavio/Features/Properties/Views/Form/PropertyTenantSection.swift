//
//  PropertyTenantSection.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 12/10/26.
//

import SwiftUI

struct PropertyTenantSection: View {

    var body: some View {
        Section("Inquilino") {
            PropertyLabeledContent(textPropertyLabel: "Nome", iconPropertyLabel: "person", textFieldPlaceholder: "Ex: Júlio Almeida Santos", textFieldHasUnit: false, textFieldIsNumber: false, textFieldCharacterLimit: 45, textFieldType: .tenantName)

            PropertyLabeledContent(textPropertyLabel: "Email", iconPropertyLabel: "envelope", textFieldPlaceholder: "Ex: email@email.com", textFieldHasUnit: false, textFieldIsNumber: false, textFieldCharacterLimit: 30, textFieldType: .tenantEmail)

            PropertyLabeledContent(textPropertyLabel: "CPF", iconPropertyLabel: "person.text.rectangle", textFieldPlaceholder: "Ex: 000.000.000-00", textFieldHasUnit: false, textFieldIsNumber: true, textFieldCharacterLimit: 14, textFieldType: .tenantCPF)

            PropertyLabeledContent(textPropertyLabel: "Telefone", iconPropertyLabel: "phone", textFieldPlaceholder: "Ex: (99) 99999-9999", textFieldHasUnit: false, textFieldIsNumber: true, textFieldCharacterLimit: 15, textFieldType: .tenantPhone)
        }
    }
}

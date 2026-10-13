//
//  PropertyInfoSection.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 12/10/26.
//


import SwiftUI

/// Nome, tipo e área do imóvel.
struct PropertyInfoSection: View {

    @Binding var propertyType: PropertyType

    var body: some View {
        Section("Informações do Imóvel") {
            PropertyLabeledContent(textPropertyLabel: "Nome", iconPropertyLabel: "pencil.line", textFieldPlaceholder: "Ex: Casa 1", textFieldHasUnit: false, textFieldIsNumber: false, textFieldCharacterLimit: 20, textFieldType: .name, isRequired: true)

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

            PropertyLabeledContent(textPropertyLabel: "Área", iconPropertyLabel: "ruler", textFieldPlaceholder: "Ex: 32", textFieldHasUnit: true, textFieldUnit: "m²", textFieldIsNumber: true, textFieldType: .area, isRequired: true)
        }
    }
}

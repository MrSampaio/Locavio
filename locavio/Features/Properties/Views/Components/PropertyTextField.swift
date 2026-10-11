//
//  PropertyTextField.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 06/10/26.
//

import SwiftUI

struct PropertyTextField: View {
    
    @Environment(PropertiesViewModel.self) private var viewModel
    
    let placeholder: String
    let content: String?
    let hasUnit: Bool
    let unit: String?
    let isNumber: Bool
    let characterLimit: Int?
    let propertyFieldType: PropertyFieldType
    
    @State private var textDisplayed: String = ""
    
    var body: some View {
        HStack(spacing: 5) {
            TextField(placeholder, text: $textDisplayed)
                .autocorrectionDisabled(true)
                // todos os campos numéricos usam máscara só com dígitos, então não precisa de vírgula/ponto
                .keyboardType(isNumber ? .numberPad : .default)
                .onChange(of: textDisplayed) { _, newValue in
                    // 1. aplica a máscara do campo
                    var processedValue = propertyFieldType.format(newValue)
                    
                    // 2. respeita o limite de caracteres
                    if let limit = characterLimit, processedValue.count > limit {
                        processedValue = String(processedValue.prefix(limit))
                    }
                    
                    if processedValue != textDisplayed {
                        textDisplayed = processedValue
                    }
                    
                    viewModel.setValueToPropertyDraft(processedValue, propertyFieldType: propertyFieldType)
                }
                // draft -> campo: quando algo de fora altera o draft (ex.: preenchimento pelo CEP),
                // o campo acompanha. Se o valor já é igual, não faz nada (evita loop).
                .onChange(of: viewModel.draftValue(for: propertyFieldType)) { _, newValue in
                    if newValue != textDisplayed {
                        textDisplayed = newValue
                    }
                }
                .onAppear {
                    if let content {
                        textDisplayed = content
                    }
                }
            
            if hasUnit, let unitContent = unit {
                Text(unitContent)
                    .foregroundStyle(textDisplayed.isEmpty ? .tertiary : .primary)
            }
        }
    }
}

#Preview {
    
    @Previewable @State var placeholder = "Ex: 32"
    var hasUnit = true
    var unit = "m²"
    var isNumber = true
    var characterLimit = 10
    
    PropertyTextField(placeholder: placeholder, content: nil, hasUnit: hasUnit, unit: unit, isNumber: isNumber, characterLimit: characterLimit, propertyFieldType: .name)
        .environment(PropertiesViewModel())
}

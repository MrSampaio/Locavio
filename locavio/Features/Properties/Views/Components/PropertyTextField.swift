//
//  PropertyTextField.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 06/10/26.
//

import SwiftUI

struct PropertyTextField: View {
    
    @Environment(PropertiesViewModel.self) private var viewModel
    
    var placeholder: String
    var content: String?
    var hasUnit: Bool
    var unit: String?
    var isNumber: Bool
    var characterLimit: Int
    var propertyFieldType: PropertyFieldType
    
    @State private var textDisplayed = ""
    
    var body: some View {
        HStack(spacing: 5) {
            TextField(placeholder, text: $textDisplayed)
                .multilineTextAlignment(.trailing)
                .keyboardType(!isNumber ? .default : .decimalPad)
                .onChange(of: textDisplayed) { _, newValue in
                    var processedValue = newValue
                    
                    if processedValue.count > characterLimit {
                        processedValue = String(processedValue.prefix(characterLimit))
                    }
                    
                    if processedValue != textDisplayed {
                        textDisplayed = processedValue
                    }
                    
                    viewModel.setValueToPropertyDraft(processedValue, propertyFieldType: propertyFieldType)
                }
                .onAppear {
                    if let textFieldContent = content {
                        textDisplayed = textFieldContent
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
    
    PropertyTextField(placeholder: placeholder, hasUnit: hasUnit, unit: unit, isNumber: isNumber, characterLimit: characterLimit, propertyFieldType: .name)
        .environment(PropertiesViewModel())
}

//
//  PropertyTextField.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 06/10/26.
//

import SwiftUI
import Combine

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
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 5) {
            TextField(placeholder, text: $textDisplayed)
                .focused($isFocused)
                .autocorrectionDisabled(true)
                .keyboardType(!isNumber ? .default : .decimalPad)
                .onChange(of: isFocused) { _, isNowFocused in
                    if !isNowFocused && propertyFieldType == .profit {
                        var cleanText = textDisplayed.replacingOccurrences(of: ".", with: "")
                        cleanText = cleanText.replacingOccurrences(of: ",", with: ".")
                        cleanText = cleanText.filter { $0.isNumber || $0 == "." }
                        
                        if let value = Double(cleanText) {
                            textDisplayed = value.formatted(.currency(code: "BRL").locale(Locale(identifier: "pt_BR")))
                            viewModel.setValueToPropertyDraft(textDisplayed, propertyFieldType: propertyFieldType)
                        }
                    } else if isNowFocused && propertyFieldType == .profit {
                        formatAsDouble()
                    }
                }
                .onChange(of: textDisplayed) { _, newValue in
                    var processedValue = newValue
                    
                    if let limit = characterLimit, processedValue.count > limit {
                        processedValue = String(processedValue.prefix(limit))
                        
                        if processedValue != textDisplayed {
                            textDisplayed = processedValue
                        }
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
    
    private func formatAsDouble() {
        var cleaned = textDisplayed.replacingOccurrences(of: ".", with: "")
        textDisplayed = cleaned.filter { $0.isNumber || $0 == "," }
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

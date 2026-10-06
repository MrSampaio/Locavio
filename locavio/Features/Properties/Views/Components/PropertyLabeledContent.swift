//
//  PropertyLabeledContent.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 06/10/26.
//

import SwiftUI

struct PropertyLabeledContent: View {
    
    var textPropertyLabel: String
    var iconPropertyLabel: String
    var textFieldPlaceholder: String
    var textFieldContent: String?
    var textFieldHasUnit: Bool
    var textFieldUnit: String?
    var textFieldIsNumber: Bool
    var textFieldCharacterLimit: Int
    var textFieldType: PropertyFieldType
    
    var body: some View {
        HStack(spacing: 12) {
            iconLabel(textPropertyLabel, systemImage: iconPropertyLabel)
                .lineLimit(1)
                .layoutPriority(1)
            
            PropertyTextField(placeholder: textFieldPlaceholder, content: textFieldContent, hasUnit: textFieldHasUnit, unit: textFieldUnit, isNumber: textFieldIsNumber, characterLimit: textFieldCharacterLimit, propertyFieldType: textFieldType)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    private func iconLabel(_ label: String, systemImage: String) -> some View {
        Label {
            Text(label)
        } icon: {
            Image(systemName: systemImage)
                .foregroundStyle(.accent)
        }
    }
}

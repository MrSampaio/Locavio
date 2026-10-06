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
        LabeledContent {
            PropertyTextField(placeholder: textFieldPlaceholder, content: textFieldContent, hasUnit: textFieldHasUnit, unit: textFieldUnit, isNumber: textFieldIsNumber, characterLimit: textFieldCharacterLimit, propertyFieldType: textFieldType)
                .frame(maxWidth: .infinity, alignment: .trailing)
        } label: {
            iconLabel(textPropertyLabel, systemImage: iconPropertyLabel)
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

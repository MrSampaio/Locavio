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
    var textFieldCharacterLimit: Int?
    var textFieldType: PropertyFieldType
    
    var body: some View {
        HStack(alignment: .top) {
            
            Image(systemName: iconPropertyLabel)
                .foregroundStyle(.accent)
            
            VStack(alignment: .leading) {
                Text(textPropertyLabel)
                    .font(.subheadline.bold())
                
                PropertyTextField(placeholder: textFieldPlaceholder, content: textFieldContent, hasUnit: textFieldHasUnit, unit: textFieldUnit, isNumber: textFieldIsNumber, characterLimit: textFieldCharacterLimit, propertyFieldType: textFieldType)
            }
        }
    }
    
}

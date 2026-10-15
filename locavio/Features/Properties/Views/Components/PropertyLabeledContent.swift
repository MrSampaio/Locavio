//
//  PropertyLabeledContent.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 06/10/26.
//

import SwiftUI

struct PropertyLabeledContent: View {
    
    @Environment(PropertiesViewModel.self) private var viewModel

    private var isFieldEmpty: Bool {
        switch textFieldType {
        case .cep:
            return viewModel.propertyDraft.cep.isEmpty
        case .number:
            return viewModel.propertyDraft.number.trimmingCharacters(in: .whitespaces).isEmpty
        case .area:
            return viewModel.propertyDraft.area.isEmpty
        case .name:
            return viewModel.propertyDraft.name.trimmingCharacters(in: .whitespaces).isEmpty
        case .profit:
            return viewModel.propertyDraft.profit.isEmpty
        default:
            return false
        }
    }

    var textPropertyLabel: String
    var iconPropertyLabel: String
    var textFieldPlaceholder: String
    var textFieldContent: String?
    var textFieldHasUnit: Bool
    var textFieldUnit: String?
    var textFieldIsNumber: Bool
    var textFieldCharacterLimit: Int?
    var textFieldType: PropertyFieldType
    var isRequired: Bool = false

    var body: some View {
        HStack(alignment: .top) {

            Image(systemName: iconPropertyLabel)
                .foregroundStyle(.accent)

            VStack(alignment: .leading) {
                HStack(spacing: 4) {
                    Text(textPropertyLabel)
                        .font(.subheadline.bold())

                    if isRequired && isFieldEmpty{
                        Text("* Campo obrigatório")
                            .foregroundStyle(.red)
                            .font(.caption)
                            .accessibilityLabel("Campo obrigatório")
                    }
                }

                PropertyTextField(
                    placeholder: textFieldPlaceholder,
                    content: textFieldContent,
                    hasUnit: textFieldHasUnit,
                    unit: textFieldUnit,
                    isNumber: textFieldIsNumber,
                    characterLimit: textFieldCharacterLimit,
                    propertyFieldType: textFieldType
                )
            }
        }
    }
}



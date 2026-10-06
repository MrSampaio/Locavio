//
//  NewPropertyView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI

struct NewPropertySheet: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(PropertiesViewModel.self) private var viewModel
    @Environment(PropertiesCoordinator.self) private var coordinator
    
    @State private var propertyType: PropertyType = .other
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("Informações do Imóvel") {
                        PropertyLabeledContent(textPropertyLabel: "Nome do Imóvel", iconPropertyLabel: "pencil.line", textFieldPlaceholder: "Ex: Casa 1", textFieldHasUnit: false, textFieldIsNumber: false, textFieldCharacterLimit: 50, textFieldType: .name)
                    }
                }
            }
            .toolbar {
                SheetsToolbar(onConfirm: {
                    
                }, onClose: {
                    dismiss()
                }, title: "Adicionar Imóvel")
            }
        }
    }
}

#Preview {
    NewPropertySheet()
        .environment(PropertiesViewModel())
        .environment(PropertiesCoordinator())
}

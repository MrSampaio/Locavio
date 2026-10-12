//
//  DocumentInput.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation
import SwiftUI

struct DocumentTextField: View {
    
    // binding para atualizar o texto do text field
    @Binding var text: String
    
    // recebe o tipo de documento
    var documentType: DocumentTypeModel
    
    // variáveis computadas para mudar o conteúdo do text field de acordo com a seleção
    private var labelTitle: String {
        documentType == .pf ? "CPF" : "CNPJ"
    }
    
    private var inputPlaceholder: String {
        documentType == .pf ? "Ex: 000.000.000-00" : "Ex: 00.000.000/0001-00"
    }
    
    
    var body: some View {
        HStack(spacing: 16) {
            
            Image(systemName: "person.text.rectangle")
                .font(.title3)
                .foregroundColor(.accentColor)
            
            // texto dinâmico
            Text(labelTitle)
                .font(.body)
            
            Spacer()
            
            TextField(inputPlaceholder, text: $text)
                .multilineTextAlignment(.trailing)
                .keyboardType(.numberPad) // abre o teclado numérico
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
//        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    VStack(spacing: 20) {
        DocumentTextField(text: .constant(""), documentType: .pf)
        
    }
}

//
//  DocumentTypePicker.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation
import SwiftUI

struct DocumentTypePicker: View {
    
    // @binding que recebe o enum de tipos de documento
    @Binding var selection: DocumentTypeModel
    
    var body: some View {
        VStack(spacing: 0){
            HStack(spacing: 16){
                Image(systemName: "building.columns")
                    .font(.title3)
                    .foregroundColor(.accentColor)
                
                Text("Natureza Jurídica")
                    .font(.body)
                
                Spacer()
                
                Menu {
                    Picker(selection: $selection, label: Text("")) {
                        ForEach(DocumentTypeModel.allCases, id: \.self) { type in
                            // text extenso na lista aberta
                            Text(type.description).tag(type)
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        // sigla quando está fechado
                        Text(selection.rawValue)
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .tint(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            
        }
    }
}

#Preview {
    DocumentTypePicker(selection: .constant(.pf))
}

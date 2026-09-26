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
                
                Picker(selection: $selection, label: Text("")) {
                    ForEach(DocumentTypeModel.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .tint(.accentColor)
            }
            .frame(width: .infinity)
            
            
        }
    }
}

#Preview {
    DocumentTypePicker(selection: .constant(.pf))
}

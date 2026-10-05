//
//  CallDescriptionField.swift
//  locavio
//
//  Created by Mirella Bransford Lourenço on 05/10/26.
//

import SwiftUI

struct CallDescriptionField: View {
    
    @Binding var text: String
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text("Descrição")
                .font(.title3)
                .fontWeight(.semibold)
            
            TextField("", text: $text, axis: .vertical)
                .font(.body)
                .foregroundStyle(
                    colorScheme == .dark
                    ? Color(red: 174 / 255, green: 180 / 255, blue: 184 / 255)
                    : Color(red: 142 / 255, green: 142 / 255, blue: 147 / 255)
                )
                .lineLimit(3)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(height: 120, alignment: .topLeading)
                .frame(maxWidth: .infinity)
                .background(
                    colorScheme == .dark
                    ? Color(red: 21 / 255, green: 45 / 255, blue: 57 / 255)
                    : Color.white
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 24)
                )
        }
        .frame(maxWidth: .infinity)
    }
}

struct CallDescriptionField_Previews: PreviewProvider {
    static var previews: some View {
        CallDescriptionField(
            text: .constant(
                "Torneira da cozinha rachou e precisa ser trocada."
            )
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .background(Color(UIColor.appBg))
    }
}

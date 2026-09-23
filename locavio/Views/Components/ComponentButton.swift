//
//  ComponentButton.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 23/09/26.
//

import SwiftUI

struct ComponentButton: View {
    
    var textButton: String = "Continuar"
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(textButton)
                .font(.callout)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color.accent)
                .clipShape(
                    RoundedRectangle(cornerRadius: 20)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ComponentButton(
        action: {}
    )
}

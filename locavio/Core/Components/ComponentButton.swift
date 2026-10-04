//
//  ComponentButton.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 23/09/26.
//
import SwiftUI

enum ButtonVariant {
    case primary // botao com accent color
    case secondary // botao com cor personalizada
}

struct ComponentButton: View {
    
    var textButton: String = "Continuar"
    let action: () -> Void
//    var backgroundColor: Color = .accent
    var variant: ButtonVariant = .primary
    
    var body: some View {
        Group {
            if variant == .primary {
                baseButton
                    .foregroundStyle(.white)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

            } else {
                baseButton
                    .foregroundStyle(.primary)
                    .buttonStyle(.glass)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }
    
    private var baseButton: some View {
        Button(action: action) {
            Text(textButton)
                .font(.headline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 44)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        // botão padrão (primary)
        ComponentButton(
            action: {}
        )
        
        // botão Secundário (transparente com o outro efeito)
        ComponentButton(
            textButton: "Cancelar",
            action: {},
            variant: .secondary
        )
        
    }
    .padding()
}

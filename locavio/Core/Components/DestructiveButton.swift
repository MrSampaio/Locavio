//
//  DestructiveButton.swift
//  locavio
//
//  Created by Julio Sampaio on 04/10/26.
//

import Foundation
import SwiftUI

struct DestructiveButton: View {
    let text: String
    let action: () -> Void
    let useGlass: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    init(
        text: String,
        action: @escaping () -> Void,
        useGlass: Bool = true
    ) {
        self.text = text
        self.action = action
        self.useGlass = useGlass
    }
    
    var body: some View {
        if useGlass {
            Button(role: .destructive, action: action) {
                Text(text)
                    .font(.headline)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 44)
            }
            .buttonStyle(.glass)
            .foregroundStyle(.red)
            
        } else {
            Button(role: .destructive, action: action) {
                Text(text)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color(hex: "FF383C"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 51)
                    .background(
                        colorScheme == .dark
                        ? Color(hex: "2C2C2E")
                        : Color(hex: "E5E5EA")
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        DestructiveButton(
            text: "Apagar",
            action: {}
        )
        
        DestructiveButton(
            text: "Fechar chamado",
            action: {},
            useGlass: false
        )
    }
    .padding()
}

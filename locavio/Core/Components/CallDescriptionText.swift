//
//  CallDescriptionText.swift
//  locavio
//
//  Created by Mirella Bransford Lourenço on 05/10/26.
//

import SwiftUI

struct CallDescriptionText: View {
    
    let description: String
    let items: [(name: String, value: String)]
    let total: String
    let closeAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            
            VStack(alignment: .leading, spacing: 12) {
                
                Text("Descrição")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
            }
            
            MaintenanceValues(
                items: items,
                total: total
            )
            
            DestructiveButton(
                text: "Fechar chamado",
                action: closeAction,
                useGlass: false
            )
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
        .glassEffect(
            .regular,
            in: .rect(cornerRadius: 16)
        )
    }
}

#Preview {
    ZStack {
        
        Color(UIColor.appBg)
            .ignoresSafeArea()
        
        CallDescriptionText(
            description: "Torneira da cozinha rachou e precisa ser trocada com urgência pois está vazando.",
            items: [
                ("Torneira", "R$ 350"),
                ("Veda Rosca", "R$ 20")
            ],
            total: "R$ 370",
            closeAction: {
                print("Chamado fechado")
            }
        )
        .padding(.horizontal, 11)
    }
}

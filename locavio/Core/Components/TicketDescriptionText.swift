//
//  CallDescriptionText.swift
//  locavio
//
//  Created by Mirella Bransford Lourenço on 05/10/26.
//

import SwiftUI

struct TicketDescriptionText: View {
    
    let description: String
    let items: [(name: String, value: String)]
    let total: String
    let isConcluded: Bool
    let closeAction: () -> Void
    
    var body: some View {
        ZStack{
            Color(UIColor.bgForm)
                .ignoresSafeArea()
            
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
                
                if !isConcluded {
                    DestructiveButton(
                        text: "Fechar chamado",
                        action: closeAction,
                        useGlass: false
                    )
                }
                
//                DestructiveButton(
//                    text: "Fechar chamado",
//                    action: closeAction,
//                    useGlass: false
//                )
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
}

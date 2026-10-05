//
//  CallDescriptionText.swift
//  locavio
//
//  Created by Mirella Bransford Lourenço on 05/10/26.
//

import SwiftUI

struct CallDetails: View {
    
    let description: String
    let items: [(name: String, value: String)]
    let total: String
    let closeAction: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
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
                 
            VStack(alignment: .leading, spacing: 16) {
                
                Text("Valores")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                VStack(spacing: 0) {
                    
                    ForEach(items.indices, id: \.self) { index in
                        
                        HStack {
                            
                            Text(items[index].name)
                                .font(.body)
                            
                            Spacer()
                            
                            Text(items[index].value)
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 51)
                        
                        if index < items.count - 1 {
                            Divider()
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        
                        Text("Total")
                            .font(.body)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text(total)
                            .font(.body)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 51)
                }
            }
            
            Button {
                closeAction()
            } label: {
                Text("Fechar chamado")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(
                        Color(hex: "FF383C")
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 51)
                    .background(
                        colorScheme == .dark
                        ? Color(hex: "2C2C2E")
                        : Color(hex: "E5E5EA")
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16)
                    )
                    .contentShape(
                        RoundedRectangle(cornerRadius: 16)
                    )
            }
            .buttonStyle(.plain)
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
        
        CallDetails(
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

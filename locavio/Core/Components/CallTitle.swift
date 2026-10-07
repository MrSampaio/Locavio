//
//  CallTitle.swift
//  locavio
//
//  Created by Mirella Bransford Lourenço on 07/10/26.
//

import SwiftUI

struct CallTitle: View {
    
    let title: String
    let callNumber: String
    let status: String
    let propertyName: String
    let date: String
    
    var body: some View {
        VStack(spacing: 8) {
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 12) {
                
                Text("Chamado Nº \(callNumber)")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                
                TagBadgeView(
                    text: status,
                    color: .orange
                )
            }
            
            HStack(spacing: 8) {
                
                Image(systemName: "house.fill")
                    .foregroundStyle(.secondary)
                
                Text(propertyName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Image(systemName: "clock.fill")
                    .foregroundStyle(.secondary)
                
                Text(date)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CallTitle(
        title: "Trocar torneira",
        callNumber: "121311",
        status: "Aberto",
        propertyName: "Casa 1",
        date: "18/09/2026 às 12:20"
    )
    .padding()
}

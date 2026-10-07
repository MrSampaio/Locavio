//
//  MaintenceValues.swift
//  locavio
//
//  Created by Mirella Bransford Lourenço on 07/10/26.
//

import SwiftUI

struct MaintenanceValues: View {
    
    let items: [(name: String, value: String)]
    let total: String
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Valores")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            VStack(spacing: 0) {
                
                ForEach(items.indices, id: \.self) { index in
                    
                    HStack {
                        
                        Text(items[index].name)
                            .font(.body)
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        Text(items[index].value)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 51)
                    
                    if index < items.count - 1 {
                        Divider()
                            .overlay(
                                colorScheme == .dark
                                ? Color.white.opacity(0.12)
                                : Color.black.opacity(0.08)
                            )
                    }
                }
                
                Divider()
                    .overlay(
                        colorScheme == .dark
                        ? Color.white.opacity(0.12)
                        : Color.black.opacity(0.08)
                    )
                
                HStack {
                    
                    Text("Total")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Text(total)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 51)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ZStack {
        Color(UIColor.appBg)
            .ignoresSafeArea()
        
        MaintenanceValues(
            items: [
                ("Torneira", "R$ 350"),
                ("Veda Rosca", "R$ 20")
            ],
            total: "R$ 370"
        )
        .padding(.horizontal, 24)
    }
}

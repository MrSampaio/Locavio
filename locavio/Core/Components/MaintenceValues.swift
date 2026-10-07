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
    
    var body: some View {
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
    }
}

#Preview {
    MaintenanceValues(
        items: [
            ("Torneira", "R$ 350"),
            ("Veda Rosca", "R$ 20")
        ],
        total: "R$ 370"
    )
    .padding(.horizontal, 24)
}

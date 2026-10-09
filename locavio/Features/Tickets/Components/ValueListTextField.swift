//
//  ValueListTextField.swift
//  locavio
//
//  Created by Mirella Bransford Lourenço on 08/10/26.
//

import SwiftUI

struct ValueListItem: Identifiable {
    
    let id = UUID()
    
    var name: String
    var value: String
}

struct ValueListTextField: View {
    
    @Binding var items: [ValueListItem]
    
    let total: String
    let onDelete: (ValueListItem) -> Void
    let onAdd: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Valores")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 0) {
                
                ForEach($items) { $item in
                    
                    HStack(spacing: 12) {
                        
                        Button {
                            if let itemToDelete = items.first(
                                where: { $0.id == item.id }
                            ) {
                                onDelete(itemToDelete)
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.red)
                        }
                        .buttonStyle(.plain)
                        
                        TextField(
                            "Item",
                            text: $item.name
                        )
                        .font(.body)
                        .foregroundStyle(.secondary)
                        
                        TextField(
                            "Valor",
                            text: $item.value
                        )
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                    }
                    .frame(height: 66)
                    
                    if item.id != items.last?.id {
                        Divider()
                            .padding(.horizontal, 12)
                    }
                }
                
                Button {
                    onAdd()
                } label: {
                    HStack(spacing: 12) {
                        
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.green)
                        
                        Text("Adicionar valor")
                            .font(.body)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                    }
                    .frame(height: 66)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .background(
                colorScheme == .dark
                ? Color.black
                : Color.white
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 24)
            )
            
            HStack {
                
                Text("Total")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(total)
                    .font(.title3)
            }
            .padding(.horizontal, 12)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }
}

#Preview {
    ValueListTextField(
        items: .constant([
            ValueListItem(
                name: "Torneira",
                value: "R$ 350,00"
            ),
            ValueListItem(
                name: "Veda-rosca",
                value: "R$ 20,00"
            )
        ]),
        total: "R$ 370,00",
        onDelete: { item in
            print("Excluir: \(item.name)")
        },
        onAdd: {
            print("Adicionar valor")
        }
    )
    .padding(16)
    .background(
        Color(UIColor.appBg)
    )
}

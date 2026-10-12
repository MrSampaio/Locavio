//
//  Contract.swift
//  locavio
//
//  Created by Mirella Bransford Lourenço on 01/10/26.
//
import SwiftUI

struct ContractComponent: View {
    
    let contractName: String?
    let attachmentDate: Date?
    let onToggle: () -> Void
    let onOpen: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            
            Button(action: onToggle) {
                Image(systemName: contractName != nil ? "minus" : "plus")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 24, height: 24)
                    .background(contractName != nil ? .red : .green)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            
            if let contractName {
                
                Button(action: onOpen) {
                    HStack(spacing: 16) {
                        Image(systemName: "doc")
                            .font(.title3)
                            .foregroundStyle(Color.accentColor)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(contractName)
                                .font(.body)
                                .lineLimit(1)
                            
                            if let attachmentDate {
                                Text("Anexado em: \(attachmentDate.formatted(date: .numeric, time: .omitted))")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
            } else {
                
                Text("Adicionar contrato")
                
                Spacer()
            }
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
    }
}

// teste

#Preview {
    Form {
        Section("Contrato") {
            ContractComponent(contractName: nil, attachmentDate: nil, onToggle: {}, onOpen: {})
            ContractComponent(contractName: "Contrato_AlbertoCaeiro_Casa", attachmentDate: .now, onToggle: {}, onOpen: {})
        }
    }
}

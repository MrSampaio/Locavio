//
//  Contract.swift
//  locavio
//
//  Created by Mirella Bransford Lourenço on 01/10/26.
//
import SwiftUI

struct ContractComponent: View {
    
    let contractName: String?
    let attachmentDate: String?
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text("CONTRATO")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 16) {
                
                Button(action: action) {
                    Image(systemName: contractName != nil ? "minus" : "plus")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(width: 24, height: 24)
                        .background(contractName != nil ? .red : .green)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                
                if let contractName {
                    
                    Image(systemName: "doc")
                        .font(.title3)
                        .foregroundStyle(Color.accentColor)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(contractName)
                            .font(.body)
                            .lineLimit(1)
                        
                        if let attachmentDate {
                            Text("Anexado em: \(attachmentDate)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                    
                } else {
                    
                    Text("Adicionar contrato")
                        .font(.body)
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 24)
            )
        }
    }
}

// teste

#Preview {
    VStack(spacing: 24) {
        
        ContractComponent(
            contractName: nil,
            attachmentDate: nil,
            action: {}
        )
        
        ContractComponent(
            contractName: "Contrato_AlbertoCaeiro_Casa",
            attachmentDate: "09/09/2026",
            action: {}
        )
    }
    .padding()
}

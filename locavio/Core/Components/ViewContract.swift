//
//  ViewContract.swift
//  locavio
//
//  Created by Mirella Bransford Lourenço on 02/10/26.
//

import SwiftUI

struct ViewContractComponent: View {
    
    let contractName: String
    let attachmentDate: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                
                Image(systemName: "doc")
                    .font(.title3)
                    .foregroundStyle(Color.accentColor)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(contractName)
                        .font(.body)
                        .foregroundStyle(.black)
                        .lineLimit(1)
                    
                    Text("Anexado em: \(attachmentDate)")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 75)
            .background(Color(hex: "E0E0E5"))
            .clipShape(
                RoundedRectangle(cornerRadius: 24)
            )
        }
        .buttonStyle(.plain)
    }
}

struct ViewContractComponent_Previews: PreviewProvider {
    static var previews: some View {
        ViewContractComponent(
            contractName: "Contrato_AlbertoCaeiro_Casa1",
            attachmentDate: "09/09/2026",
            action: {}
        )
        .padding(.horizontal, 16)
    }
}

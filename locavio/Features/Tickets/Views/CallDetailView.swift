//
//  CallDetailView.swift
//  locavio
//
//  Created by Mirella Bransford Lourenço on 07/10/26.
//

import SwiftUI

struct CallDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let imageName: String
    let title: String
    let callNumber: String
    let status: String
    let propertyName: String
    let date: String
    let description: String
    let items: [(name: String, value: String)]
    let total: String
    let closeAction: () -> Void
    let editAction: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                
                CallTitle(
                    title: title,
                    callNumber: callNumber,
                    status: status,
                    propertyName: propertyName,
                    date: date
                )
                
                CallDescriptionText(
                    description: description,
                    items: items,
                    total: total,
                    closeAction: closeAction
                )
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle("Detalhes do chamado")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            SheetsToolbar(
                onConfirm: editAction,
                onClose: {
                    dismiss()
                },
                title: "Detalhes do chamado",
                isDetail: true
            )
        }
    }
}

#Preview {
    NavigationStack {
        CallDetailView(
            imageName: "CasaText",
            title: "Trocar torneira",
            callNumber: "121311",
            status: "Aberto",
            propertyName: "Casa 1",
            date: "18/09/2026 às 12:20",
            description: "Torneira da cozinha rachou e precisa ser trocada com urgência pois está vazando.",
            items: [
                ("Torneira", "R$ 350"),
                ("Veda Rosca", "R$ 20")
            ],
            total: "R$ 370",
            closeAction: {
                print("Chamado fechado")
            },
            editAction: {
                print("Editar chamado")
            }
        )
    }
}

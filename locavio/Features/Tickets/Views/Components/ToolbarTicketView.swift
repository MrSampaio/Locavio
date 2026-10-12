//
//  ToolbarTicketView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 07/10/26.
//

import SwiftUI
 
struct ToolbarTicketView: ToolbarContent {
    var onAdd: () -> Void
 
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: onAdd) {
                Image(systemName: "plus")
                    .foregroundStyle(.white)
            }
            .accessibilityLabel("Adicionar")
            .buttonStyle(.glassProminent)
            .tint(.accentColor)
        }
    }
}
 
#Preview {
    NavigationStack {
        Color.clear
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarTicketView(
                    onAdd: { print("Editar") }
                )
            }
    }
}
    


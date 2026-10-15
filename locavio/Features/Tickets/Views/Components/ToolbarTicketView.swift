//
//  ToolbarTicketView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 07/10/26.
//

import SwiftUI
import TipKit
 
struct ToolbarTicketView: ToolbarContent {
    var onAdd: () -> Void
    var tip: (any Tip)? = nil
 
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: onAdd) {
                Image(systemName: "plus")
                    .foregroundStyle(.white)
            }
            .popoverTip(tip)
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
    


//
//  ToolbarDetailsComponentView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 29/09/26.
//



import SwiftUI
 
struct ToolbarDetailsComponentView: ToolbarContent {
    var onEdit: () -> Void
 
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: onEdit) {
                Image(systemName: "square.and.pencil")
            }
            .accessibilityLabel("Editar")
        }
    }
}
 
#Preview {
    NavigationStack {
        Color.clear
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarDetailsComponentView(
                    onEdit: { print("Editar") }
                )
            }
    }
}
    
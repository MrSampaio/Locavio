//
//  ToolbarComponentView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 27/09/26.
//
import SwiftUI

import SwiftUI

struct AppToolbar: ToolbarContent {
    var onMore: () -> Void
    var onAdd: () -> Void

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: onMore) {
                Image(systemName: "ellipsis")
            }
        }

        ToolbarSpacer(.fixed, placement: .topBarTrailing)

        ToolbarItem(placement: .topBarTrailing) {
            Button(action: onAdd) {
                Image(systemName: "plus")
                    .foregroundStyle(.white)
            }
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
                AppToolbar(
                    onMore: { print("Opções") },
                    onAdd: { print("Adicionar") }
                )
            }
    }
}

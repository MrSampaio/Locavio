//
//  ToolbarComponentView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 27/09/26.
//
import SwiftUI

struct ToolbarComponentScreen: View {
    var body: some View {
        NavigationStack {
            List { Text("Conteúdo da tela") }
                .navigationTitle("Imóveis")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            print("Opções")
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                    }
                    ToolbarSpacer(.fixed, placement: .topBarTrailing)
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            print("Adicionar")
                        } label: {
                            Image(systemName: "plus")
                                .foregroundStyle(.white)
                        }
                        .buttonStyle(.glassProminent)
                        .tint(.accentColor)
                    }
                }
        }
    }
}

#Preview {
    ToolbarComponentScreen()
}

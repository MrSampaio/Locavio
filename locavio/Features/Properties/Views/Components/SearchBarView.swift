//
//  SearchBar.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 28/09/26.
//
import SwiftUI
struct SearchBarView: View {
    @Binding var text: String
    var prompt: String = "Pesquise seus imóveis aqui"

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField(prompt, text: $text)
                .submitLabel(.search)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 48)
        .glassEffect(.regular, in: .capsule)
    }
}




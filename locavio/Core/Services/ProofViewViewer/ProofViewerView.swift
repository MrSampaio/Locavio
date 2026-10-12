//
//  ProofViewerView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 05/10/26.
//

import SwiftUI
import PDFKit

/// Mostra o PDF guardado em `Payment.proof`.
struct ProofViewerView: View {
    let item: ProofItem
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Group {
                if let document = PDFDocument(data: item.data) {
                    PDFKitView(document: document)
                        .ignoresSafeArea(edges: .bottom)
                } else {
                    ContentUnavailableView("Não foi possível abrir o comprovante",
                                           systemImage: "doc.questionmark")
                }
            }
            .navigationTitle(item.monthText)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fechar") { dismiss() }
                }
            }
            
            .toolbarBackground(Color(.systemGroupedBackground), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        
        .presentationBackground(Color(.systemGroupedBackground))
    }
}

private struct PDFKitView: UIViewRepresentable {
    let document: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.autoScales = true
        view.backgroundColor = .systemGroupedBackground   // área em volta da página
        view.document = document
        return view
    }

    func updateUIView(_ view: PDFView, context: Context) {
        view.document = document
    }
}

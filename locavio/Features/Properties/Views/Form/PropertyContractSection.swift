//
//  PropertyContractSection.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 12/10/26.
//

import SwiftUI
import QuickLook
import UniformTypeIdentifiers

///Trabalha em cima do `contractDraft` do view model.
struct PropertyContractSection: View {

    @Environment(PropertiesViewModel.self) private var viewModel

    @State private var isImporting = false
    @State private var previewURL: URL?

    var onError: (Error) -> Void

    var body: some View {
        Section("Contrato") {
            ContractComponent(
                contractName: viewModel.contractDraft?.title,
                attachmentDate: viewModel.contractDraft?.createdAt) {
                    if viewModel.contractDraft == nil {
                        isImporting = true
                    } else {
                        viewModel.removeContractDraft()
                    }
                } onOpen: {
                    previewURL = viewModel.makeContractPreviewURL()
                }
                .fileImporter(isPresented: $isImporting, allowedContentTypes: [.pdf]) { result in
                    switch result {
                    case .success(let url):
                        do {
                            try viewModel.importContract(from: url)
                        } catch {
                            onError(error)
                        }
                    case .failure(let failure):
                        onError(failure)
                    }
                }
                .quickLookPreview($previewURL)
        }
    }
}

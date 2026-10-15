//
//  Toggle.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 01/10/26.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers
import QuickLook

struct ToggleComponentPayment: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var viewModel: PaymentToggleViewModel
    @State private var condition: Bool
    @State private var showAlert = false
    @State private var showFileImporter = false
    @State private var proofPreviewURL: URL?
    
    init(property: Property) {
        let viewModel = PaymentToggleViewModel(property: property)
        
        _viewModel = State(initialValue: viewModel)
        _condition = State(initialValue: viewModel.isPaid)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            OptionToggle(
                text: viewModel.title,
                isOn: $condition
            )
            .onChange(of: condition) { _, newValue in
                if newValue {
                    showAlert = true
                } else {
                    viewModel.setPaid(
                        false,
                        in: modelContext
                    )
                }
            }
            
            if condition {
                proofSection
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            .quaternary,
            in: RoundedRectangle(
                cornerRadius: 28,
                style: .continuous
            )
        )
        .alert(
            "Confirmar aluguel pago?",
            isPresented: $showAlert
        ) {
            Button(role: .confirm) {
                viewModel.setPaid(
                    true,
                    in: modelContext
                )
                
                condition = true
            } label: {
                Text("Sim")
            }
            
            Button("Não", role: .cancel) {
                condition = false
            }
        }
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.pdf],
            allowsMultipleSelection: false
        ) { result in
            handlePDF(result)
        }
        // abre o comprovante em tela cheia (QuickLook)
        .quickLookPreview($proofPreviewURL)
        .onChange(of: viewModel.isPaid) { _, isPaid in
            condition = isPaid
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                viewModel.refresh()
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: .NSCalendarDayChanged
            )
        ) { _ in
            viewModel.refresh()
        }
    }
    
    @ViewBuilder
    private var proofSection: some View {
        if viewModel.hasProof {
            proofRow
        } else {
            Button {
                showFileImporter = true
            } label: {
                HStack{
                    Image(systemName: "plus")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(width: 24, height: 24)
                        .background(.green)
                        .clipShape(Circle())
                    
                    Text("Adicionar comprovante")
                        .font(.body)
                    
                    
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 75)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            }
            .buttonStyle(.plain)
        }
    }
    
    // comprovante já anexado:
    // - tocar no cartão visualiza o PDF
    // - tocar no lápis (ao lado) abre o seletor pra trocar o arquivo
    private var proofRow: some View {
        HStack(spacing: 8) {
            
            Button {
                proofPreviewURL = viewModel.makeProofPreviewURL()
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: "doc")
                        .font(.title3)
                        .foregroundStyle(Color.accentColor)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(viewModel.proofName)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                        
                        Text("Anexado em: \(viewModel.proofDate)")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityHint("Abre o comprovante")
            
            Button {
                showFileImporter = true
            } label: {
                Image(systemName: "pencil")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Color.accentColor)
                    .frame(width: 44, height: 44)
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Substituir comprovante")
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .frame(height: 75)
        .background(.quaternary)
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
    }
    
    private func handlePDF(
        _ result: Result<[URL], Error>
    ) {
        switch result {
            case .success(let urls):
                guard let url = urls.first else {
                    return
                }
                
                // solicita permissão ao iOS para ler o arquivo de fora da app
                guard url.startAccessingSecurityScopedResource() else {
                    print("There ir no permission to access the file.")
                    return
                }
                
                // garante que a permissão é revogada ao terminar, evitando vazamento de memória
                defer {
                    url.stopAccessingSecurityScopedResource()
                }
                
                do {
                    let data = try Data(contentsOf: url)
                    
                    // se já existia um comprovante, o novo substitui o antigo
                    viewModel.saveProof(
                        data,
                        in: modelContext
                    )
                    
                    // força a atualização do ViewModel para a view mudar do botão "Adicionar" para o componente visual do comprovante
                    viewModel.refresh()
                    
                } catch {
                    print("Error when trying to read PDF file: \(error)")
                }
                
            case .failure(let error):
                print("Error when selecting PDF file: \(error)")
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Property.self, Owner.self, Tenant.self, Contract.self,
        Payment.self, Expenses.self, Ticket.self, Maintence.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let property = Property(title: "Casa 1", paymentDay: 10, profit: 1200)
    container.mainContext.insert(property)
    
    return ToggleComponentPayment(property: property)
        .padding()
        .modelContainer(container)
}

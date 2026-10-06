//
//  Toggle.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 01/10/26.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct ToggleComponentPayment: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase

    @State private var viewModel: PaymentToggleViewModel
    @State private var condition: Bool
    @State private var showAlert = false
    @State private var showFileImporter = false

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
                    condition = false
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
            ViewContractComponent(
                contractName: viewModel.proofName,
                attachmentDate: viewModel.proofDate,
                action: {
                    showFileImporter = true
                }
            )
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

    private func handlePDF(
        _ result: Result<[URL], Error>
    ) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else {
                return
            }

            do {
                let data = try Data(contentsOf: url)

                viewModel.saveProof(
                    data,
                    in: modelContext
                )
            } catch {
                print("Erro ao ler PDF: \(error)")
            }

        case .failure(let error):
            print("Erro ao selecionar PDF: \(error)")
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

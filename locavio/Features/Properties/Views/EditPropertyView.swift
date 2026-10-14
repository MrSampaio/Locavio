//
//  EditPropertyView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 12/10/26.
//

import SwiftUI
import SwiftData

struct EditPropertyView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(PropertiesViewModel.self) private var propertiesViewModel

    @State private var viewModel: EditPropertyViewModel

    init(property: Property) {
        _viewModel = State(initialValue: EditPropertyViewModel(property: property))
    }

    var body: some View {
        Form {
            if viewModel.isLoaded {
                PropertyPhotoSection()
                PropertyInfoSection(propertyType: $viewModel.propertyType)
                PropertyAddressSection(uf: $viewModel.uf, onError: viewModel.show)

                PropertyFinancialSection(expensesTotal: viewModel.expensesViewModel.totalExpenses) {
                    ExpensesTextFieldCard(viewModel: viewModel.expensesViewModel)
                }

                PropertyTenantSection()
                PropertyContractSection(onError: viewModel.show)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color(.appBg).ignoresSafeArea())
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            #if canImport(UIKit)
                hideKeyboard()
            #endif
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Editar Imóvel")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    save()
                } label: {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.white)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.isLoaded)
            }
        }
        .alert("Atenção!", isPresented: $viewModel.showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
        .onAppear { viewModel.load(using: propertiesViewModel) }
    }

    /// Fechar a tela é assunto da view (vem do ambiente); o view model só diz se salvou.
    private func save() {
        if viewModel.save(using: propertiesViewModel, context: context) {
            dismiss()
        }
    }
}

// MARK: - Preview

#Preview("Editar imóvel") {
    let container = try! ModelContainer(
        for: Property.self, Owner.self, Tenant.self, Contract.self,
             Payment.self, Expenses.self, Ticket.self, Maintence.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = container.mainContext

    // imóvel completo: foto, inquilino, despesas e contrato
    let tenant = Tenant(name: "Alberto Caeiro",
                        email: "bertinhocaeiro@fpessoa.com",
                        cpf: "52998224725",
                        phone: "11987654321")

    let property = Property(
        image: UIImage(named: "CasaText")?.jpegData(compressionQuality: 0.9),
        title: "Casa 1",
        type: .home,
        area: 32,
        paymentDay: 10,
        cep: "12345678",
        street: "Rua Ipê Amarelo",
        neighborhood: "Santo Amaro",
        number: "55",
        city: "São Paulo",
        uf: "SP",
        profit: 500,
        tenant: tenant
    )
    context.insert(property)

    for item in [("IPTU", 200.0), ("Condomínio", 400.0), ("Seguro", 200.0)] {
        context.insert(Expenses(property: property, title: item.0, value: item.1))
    }

    let pdf = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 595, height: 842)).pdfData { ctx in
        ctx.beginPage()
        "Contrato de teste".draw(at: CGPoint(x: 40, y: 40),
                                 withAttributes: [.font: UIFont.systemFont(ofSize: 24)])
    }
    let contract = Contract(title: "Contrato Casa 1", fileName: "contrato.pdf", createdAt: .now, pdfData: pdf)
    contract.property = property
    property.contract = contract
    context.insert(contract)

    return NavigationStack {
        EditPropertyView(property: property)
    }
    .modelContainer(container)
    .environment(PropertiesViewModel())
}

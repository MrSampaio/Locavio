//
//  Toggle.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 01/10/26.
//

import SwiftUI
import SwiftData

struct ToggleComponentPayment: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase

    @State private var viewModel: PaymentToggleViewModel
    @State private var condition: Bool
    @State private var showAlert = false

    init(property: Property) {
        let viewModel = PaymentToggleViewModel(property: property)
        _viewModel = State(initialValue: viewModel)
        _condition = State(initialValue: viewModel.isPaid)
    }

    var body: some View {
        VStack {
            OptionToggle(
                text: viewModel.title,
                isOn: $condition
            )
            .onChange(of: condition) { _, newValue in
                if newValue {
                    // só grava o pagamento depois da confirmação
                    showAlert = true
                } else {
                    viewModel.setPaid(false, in: modelContext)
                }
            }
            .alert("Confirmar aluguel pago?", isPresented: $showAlert) {
                Button(role: .confirm) {
                    viewModel.setPaid(true, in: modelContext)
                    condition = true
                } label: {
                    Text("Sim")
                }

                Button("Não", role: .cancel) {
                    condition = false
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        // Virou o mês: não há pagamento no mês novo, então o toggle volta para off
        .onChange(of: viewModel.isPaid) { _, isPaid in
            condition = isPaid
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { viewModel.refresh() }
        }
        .onReceive(NotificationCenter.default.publisher(for: .NSCalendarDayChanged)) { _ in
            viewModel.refresh()
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

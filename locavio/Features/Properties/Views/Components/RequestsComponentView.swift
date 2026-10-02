//
//  RequestsComponentView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 01/10/26.
//


//tela para o final do projeto

import SwiftUI
import SwiftData

struct RequestsComponentView: View {
    @State private var viewModel: MaintenanceRequestsViewModel

    init(property: Property) {
        _viewModel = State(initialValue: MaintenanceRequestsViewModel(property: property))
    }

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        if viewModel.isEmpty {
            Text(viewModel.emptyText)
                .foregroundStyle(.secondary)
        } else {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(viewModel.cards) { card in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(card.title)
                            .font(.title3)
                            .lineLimit(2)

                        Text(card.deadlineLabel)
                            .foregroundStyle(.secondary)

                        Text(card.deadlineText)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
                }
            }
        }
    }
}

// MARK: - Previews
 
private func makeContainer() -> ModelContainer {
    try! ModelContainer(
        for: Property.self, Owner.self, Tenant.self, Contract.self,
             Payment.self, Expenses.self, Ticket.self, Maintence.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
}
 
private func date(_ day: Int, _ month: Int, _ year: Int) -> Date {
    Calendar.current.date(from: DateComponents(year: year, month: month, day: day))!
}
 
#Preview("Com solicitações") {
    let container = makeContainer()
    let context = container.mainContext
 
    let property = Property(title: "Casa 1")
    context.insert(property)
 
    let t1 = Ticket(title: "Torneira", conclusionDate: date(27, 9, 2026), property: property)
    let t2 = Ticket(title: "Fiação", conclusionDate: date(10, 10, 2026), property: property)
    let t3 = Ticket(title: "Pintura", conclusionDate: date(25, 10, 2026), property: property)
    let t4 = Ticket(title: "Portão", property: property)   // sem prazo
    [t1, t2, t3, t4].forEach { context.insert($0) }
 
    context.insert(Maintence(ticket: t1, item: "Trocar Torneira", value: 150))
    context.insert(Maintence(ticket: t2, item: "Arrumar Fiação", value: 400))
    context.insert(Maintence(ticket: t3, item: "Pintar sala", value: 600))
    context.insert(Maintence(ticket: t3, item: "Pintar quarto", value: 500))   // 2 itens no mesmo chamado
 
    return ScrollView {
        RequestsComponentView(property: property)
            .padding()
    }
    .modelContainer(container)
}
 
#Preview("Sem solicitações") {
    let container = makeContainer()
    let property = Property(title: "Casa 1")
    container.mainContext.insert(property)
 
    return RequestsComponentView(property: property)
        .padding()
        .modelContainer(container)
}

//
//  CalendarView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//
import SwiftUI
import SwiftData

struct CalendarView: View {
    @State private var viewModel = CalendarViewModel()
    @Query(sort: \Ticket.conclusionDate) private var tickets: [Ticket]
    @Query private var properties: [Property]
    
    @Environment(CalendarCoordinator.self) private var coordinator

    var onSelect: (Ticket) -> Void = { _ in }

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        let markedDays = viewModel.daysWithTickets(from: tickets)
        let dayTickets = viewModel.tickets(from: tickets)
        let dayRents = viewModel.rents(from: properties)

        ZStack {
            Color(.appBg).ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Picker("Modo", selection: $viewModel.mode) {
                        ForEach(CalendarModel.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)

                    header
                    grid(markedDays: markedDays)
                    list(rents: dayRents, tickets: dayTickets)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Calendário")
    }

    private var header: some View {
        HStack {
            Text(viewModel.title).font(.headline)
            Spacer()
            Button { viewModel.previous() } label: { Image(systemName: "chevron.left") }
            Button { viewModel.next() } label: { Image(systemName: "chevron.right") }
                .padding(.leading, 16)
        }
        .foregroundStyle(.primary)
    }

    private func grid(markedDays: Set<Date>) -> some View {
        VStack(spacing: 4) {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }

            LazyVGrid(columns: columns) {
                ForEach(Array(viewModel.days.enumerated()), id: \.offset) { _, day in
                    if let day {
                        Button { viewModel.select(day) } label: {
                            CalendarDayCell(
                                date: day,
                                isSelected: viewModel.isSelected(day),
                                isToday: viewModel.isToday(day),
                                hasTicket: viewModel.hasTicket(on: day, in: markedDays),
                                hasPayment: viewModel.hasRent(on: day, from: properties)
                            )
                        }
                        .buttonStyle(.plain)
                    } else {
                        Color.clear.frame(height: 50)
                    }
                }
            }
        }
    }

    private func list(rents dayRents: [RentDue], tickets dayTickets: [Ticket]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.listTitle).font(.title3.bold())
            
            if dayRents.isEmpty && dayTickets.isEmpty {
                Text("Nenhum aluguel ou chamado neste dia.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(dayRents) { rent in
                    RentComponent(
                        property: rent.property,
                        dueDate: rent.date,
                        onTap: {
                            coordinator.pushToPropertyDetails(property: rent.property)
                        }
                    )
                }

                ForEach(dayTickets) { ticket in
                    TicketComponent(
                        ticket: ticket,
                        onTap: {
                            coordinator.pushToTicketDetails(ticket: ticket)
                        },
                        onEdit: {
                            coordinator.pushToEditTicket(ticket: ticket)
                        }
                    )
                }
            }
        }
    }
}


#Preview {
    let container = try! ModelContainer(
        for: Property.self, Owner.self, Tenant.self, Contract.self,
             Payment.self, Expenses.self, Ticket.self, Maintence.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = container.mainContext

    // chamado concluído hoje
    let ticket = Ticket(title: "Trocar telha", createdAt: .now, conclusionDate: .now)
    ticket.isConcluded = true
    context.insert(ticket)

    // imóvel alugado com vencimento hoje
    let tenant = Tenant(name: "Alberto Caeiro",
                        email: "bertinhocaeiro@fpessoa.com",
                        cpf: "52998224725",
                        phone: "11987654321")
    let property = Property(
        image: UIImage(named: "CasaText")?.jpegData(compressionQuality: 0.9),
        title: "Casa 1",
        type: .home,
        paymentDay: Calendar.current.component(.day, from: .now),
        tenant: tenant
    )
    context.insert(property)

    return NavigationStack { CalendarView() }
        .modelContainer(container)
        .environment(CalendarCoordinator())
}

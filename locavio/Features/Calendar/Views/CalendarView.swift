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

    var onSelect: (Ticket) -> Void = { _ in }

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        let markedDays = viewModel.daysWithTickets(from: tickets)
        let dayTickets = viewModel.tickets(from: tickets)

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
                    list(dayTickets)
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
                                hasTicket: viewModel.hasTicket(on: day, in: markedDays)
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

    private func list(_ dayTickets: [Ticket]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.listTitle).font(.title3.bold())

            if dayTickets.isEmpty {
                Text("Nenhum chamado neste dia.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(dayTickets) { ticket in
                    TicketComponent(ticket: ticket) { onSelect(ticket) }
                }
            }
        }
    }
}


#Preview {
    let container = try! ModelContainer(
        for: Ticket.self, Property.self, Maintence.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let ticket = Ticket(title: "Trocar telha", createdAt: .now, conclusionDate: .now)
    ticket.isConcluded = true
    container.mainContext.insert(ticket)

    return NavigationStack { CalendarView() }
        .modelContainer(container)
}


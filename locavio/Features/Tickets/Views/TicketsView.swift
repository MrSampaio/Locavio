//
//  TicketsView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//
import SwiftUI
import SwiftData

struct TicketsView: View {
    
    @Environment(TicketsCoordinator.self) private var coordinator
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var viewModel = TicketsViewModel()
    @Query(sort: \Ticket.createdAt, order: .reverse) private var tickets: [Ticket]

    var onAdd: () -> Void = {}
    var onSelect: (Ticket) -> Void = { _ in }
    
    var body: some View {
        
        @Bindable var bindableCoordinator = coordinator
        
        ZStack {
            Color(.appBg)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                SearchBarView(text: $viewModel.searchText)

                Picker("Filtro", selection: $viewModel.filter) {
                    ForEach(TicketsFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)

                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.visibleTickets(from: tickets)) { ticket in
                            TicketComponent(
                                ticket: ticket,
                                onTap: {
                                    coordinator.pushToTicketDetails(ticket: ticket)
                                }
                            )
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .sheet(item: $bindableCoordinator.activeSheet) { currentSheet in
                
                switch currentSheet {
                    case .addTicket:
                        CreateTicketSheet(
//                            onAdd: {
//                                do{
//                                    
//                                    print("\(viewModel.ticketTitle)")
//                                    print("saldksadksahdkjsadh")
//                                    
//                                    try viewModel
//                                        .createTicket(
//                                            context: context
//                                        )
////                                        .createTicket(
////                                            context: context,
////                                            ticketTitle: viewModel.ticketTitle,
////                                            createdAt: viewModel.createdAt,
////                                            conclusionDate: viewModel.conclusionDate,
////                                            ticketDescription: viewModel.ticketDescription,
////                                            property: viewModel.property
////                                        )
//                                    
//                                    
//                                    print("\(viewModel.ticketTitle)")
//                                    dismiss()
//                                } catch {
//                                    print("Error when trying to add new ticket: \(error)")
//                                }
//                                
//                            },
//                            onClose: {
//                                dismiss()
//                            })
                            )
                            .presentationDetents([.fraction(0.65), .large])
                            .presentationDragIndicator(.visible)
                            .presentationBackground(Color(.systemGray6))
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            
           
        }
        .navigationTitle("Chamados")
        .toolbar {
            ToolbarTicketView(onAdd: {
                coordinator.presentAddTicket()
            })
        }
        .onTapGesture {
            #if canImport(UIKit)
                hideKeyboard()
            #endif
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Ticket.self, Property.self, Maintence.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    let concluded = Ticket(title: "Trocar telha", createdAt: .now, conclusionDate: .now)
    concluded.isConcluded = true
    let open = Ticket(title: "Consertar portão", createdAt: .now)
    open.isConcluded = false

    container.mainContext.insert(concluded)
    container.mainContext.insert(open)

    return NavigationStack {
        TicketsView(onAdd: { print("Adicionar chamado") })
            .environment(TicketsCoordinator())
    }
    .modelContainer(container)
}

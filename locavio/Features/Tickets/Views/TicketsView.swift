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

            ScrollView{
                VStack(alignment: .leading, spacing: 20) {
                    SearchBarView(text: $viewModel.searchText)
                    
                    Picker("Filtro", selection: $viewModel.filter) {
                        ForEach(TicketsFilter.allCases) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.visibleTickets(from: tickets)) { ticket in
                            HStack {
                                if viewModel.isSelectionMode {
                                    Image(systemName: viewModel.selectedTickets.contains(ticket) ? "checkmark.circle.fill" : "circle")
                                        .font(.title2)
                                        .foregroundColor(viewModel.selectedTickets.contains(ticket) ? .blue : .gray)
                                        .padding(.trailing, 4)
                                        .onTapGesture {
                                            viewModel.toggleSelection(for: ticket)
                                        }
                                        .transition(.scale.combined(with: .opacity))
                                }
                                
                                TicketComponent(
                                    ticket: ticket,
                                    onTap: {
                                        if viewModel.isSelectionMode {
                                            viewModel.toggleSelection(for: ticket)
                                        } else {
                                            coordinator.pushToTicketDetails(ticket: ticket)
                                        }
                                    }
                                )
                            }
                        }
                        
                    }
                    .animation(.default, value: viewModel.isSelectionMode)
                    .scrollIndicators(.hidden)
                }
                .sheet(item: $bindableCoordinator.activeSheet) { currentSheet in
                    
                    switch currentSheet {
                        case .addTicket:
                            CreateTicketSheet()
                                .presentationDetents([.fraction(0.65), .large])
                                .presentationDragIndicator(.visible)
                                .presentationBackground(Color(.systemGray6))
                    }
                }
                .padding()
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .scrollIndicators(.hidden)
            
            
           
        }
        .navigationTitle("Chamados")
        .toolbar {
            if viewModel.isSelectionMode {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") {
                        withAnimation {
                            viewModel.isSelectionMode = false
                            viewModel.selectedTickets.removeAll()
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(role: .destructive) {
                        viewModel.showDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(viewModel.selectedTickets.isEmpty ? .gray : .red)
                    }
                    .disabled(viewModel.selectedTickets.isEmpty) // Desabilita se nada foi selecionado
                }
            } else {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Selecionar") {
                        withAnimation {
                            viewModel.isSelectionMode = true
                        }
                    }
                }
                
                ToolbarTicketView(onAdd: {
                    coordinator.presentAddTicket()
                })
            }
        }
        
        .alert("Apagar Selecionados", isPresented: $viewModel.showDeleteAlert) {
            Button("Cancelar", role: .cancel) { }
            
            Button("Apagar", role: .destructive) {
                withAnimation {
                    viewModel.deleteSelectedTickets(context: context)
                }
            }
        } message: {
            Text("Tem certeza que deseja apagar os \(viewModel.selectedTickets.count) chamados selecionados? Essa ação não pode ser desfeita.")
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

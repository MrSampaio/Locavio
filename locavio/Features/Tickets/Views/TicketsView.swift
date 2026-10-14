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
    
    // Query para verificar se o utilizador possui imóveis
    @Query private var properties: [Property]
    
    var onAdd: () -> Void = {}
    var onSelect: (Ticket) -> Void = { _ in }
    
    // closure para permitir que esta view "mude de Tab" (indo para Imóveis) caso não haja propriedades
    var onSwitchToPropertiesTab: (() -> Void)? = nil
    
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
                    
                    
                    if properties.isEmpty {
                        
                        // cenário 1: Não há imóveis (não pode criar chamado)
                        TicketsEmptyStateView(
                            stateType: .noProperties,
                            onAction: { onSwitchToPropertiesTab?() }
                        )
                        .padding(.top, 60)
                        
                    } else if tickets.isEmpty {
                        
                        // cenário 2: tem imóvel, mas NUNCA criou um chamado
                        TicketsEmptyStateView(
                            stateType: .noTickets,
                            onAction: { coordinator.presentAddTicket() }
                        )
                        .padding(.top, 60)
                        
                    } else if viewModel.visibleTickets(from: tickets).isEmpty {
                        
                        // cenário 3: a busca ou o filtro esconderam todos os resultados
                        TicketsEmptyStateView(
                            stateType: .searchEmpty
                        )
                        .padding(.top, 60)
                        
                    } else {
                        
                        // cenário 4: Mostra a lista
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
                                        },
                                        onEdit: {
                                            coordinator.pushToEditTicket(ticket: ticket)
                                        }
                                    )
                                }
                            }
                        }
                        .animation(.default, value: viewModel.isSelectionMode)
                        .scrollIndicators(.hidden)
                    }
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
            .dismissKeyboardOnTap()
        }
        .navigationTitle("Chamados")
        .toolbar {
            
            // lógica de desativar botões da Toolbar se não houver propriedades ou se estiver vazio
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
                
                // oculta o botão "Selecionar" se não houver tickets visíveis
                if !tickets.isEmpty && !viewModel.visibleTickets(from: tickets).isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Selecionar") {
                            withAnimation {
                                viewModel.isSelectionMode = true
                            }
                        }
                    }
                }
                
                // só mostra o botão de adicionar na barra se o usuário tiver propriedades
                if !properties.isEmpty {
                    ToolbarTicketView(onAdd: {
                        coordinator.presentAddTicket()
                    })
                }
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
        .scrollDismissesKeyboard(.interactively)
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
    
    let dummyProperty = Property(title: "Preview", type: .home, area: 1, paymentDay: 1, street: "", number: "", city: "", profit: 1)
    
    container.mainContext.insert(dummyProperty)
    container.mainContext.insert(concluded)
    container.mainContext.insert(open)
    
    return NavigationStack {
        TicketsView(onAdd: { print("Adicionar chamado") })
            .environment(TicketsCoordinator())
    }
    .modelContainer(container)
}

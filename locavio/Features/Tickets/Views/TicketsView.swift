//
//  TicketsView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI

struct TicketsView: View {
    
    @Environment(TicketsCoordinator.self) private var coordinator
    
    @State private var viewModel = TicketsViewModel()
    var onAdd: () -> Void = {}
    
    
    
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
        .navigationTitle("Chamados")
        .toolbar {
            ToolbarTicketView(onAdd: {
                coordinator.presentAddTicket()
            })
        }
    }
}

#Preview {
    NavigationStack {
        TicketsView(onAdd: { print("Adicionar chamado") })
            .environment(TicketsCoordinator())
    }
}

//
//  TicketsView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI

struct TicketsView: View {
    @State private var viewModel = TicketsViewModel()
    var onAdd: () -> Void = {}
    var body: some View {
        ZStack {
            Color(.appBg)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                SearchBarView(text: $viewModel.searchText)
                
                Text("Tela de chamados")
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .navigationTitle("Chamados")
        .toolbar {
            ToolbarTicketView(onAdd: onAdd)
        }
    }
}

#Preview {
    NavigationStack {
           TicketsView(onAdd: { print("Adicionar chamado") })
       }
}

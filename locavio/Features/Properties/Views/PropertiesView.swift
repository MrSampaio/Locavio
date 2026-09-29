//
//  ScreenPropertyView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 26/09/26.
//

import SwiftUI

struct PropertiesView: View {
    
    @State private var viewModel = PropertiesViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Imóveis")
                        .font(.largeTitle.bold())

                    SearchBarView(text: $viewModel.searchText)

                    Picker("Filtro", selection: $viewModel.filter) {
                        ForEach(PropertyFilter.allCases) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .pickerStyle(.segmented)

                    LazyVStack(spacing: 16) {
                        // seus PropertyCardView entram aqui
                    }
                }
                .padding(.horizontal)
            }
            .navigationBarTitleDisplayMode(.inline) // sem .navigationTitle
            .toolbar {
                AppToolbar(
                    onMore: { viewModel.showOptions() },
                    onAdd: { viewModel.addProperty() }
                )
            }
        }
    }
}

#Preview {
    PropertiesView()
}




// exemplos chamada coordinator:

//Button(action: {
//    coordinator.path.append(.newProperty)
//}) {
//    Text("Adicionar Novo Imóvel")
//}
//
//// Exemplo passando um parâmetro para a rota de detalhes
//Button(action: {
//    let idDoImovel = 1 // Isso viria do seu SwiftData
//    coordinator.path.append(.details(id: idDoImovel))
//}) {
//    Text("Ver Detalhes do Imóvel 1")
//}

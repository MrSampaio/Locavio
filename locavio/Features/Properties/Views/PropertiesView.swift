//
//  ScreenPropertyView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 26/09/26.
//

import SwiftUI
import SwiftData

struct PropertiesView: View {
    @State private var viewModel = PropertiesViewModel()
    
    @Environment(AppleAuthManager.self) private var authManager
   
    @Query private var properties: [Property]
    
    @Query private var users: [Owner]
    
    private var visibleProperties: [Property] {
        viewModel.visibleProperties(from: properties)
    }
    
    var body: some View {
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
                    ForEach(visibleProperties) { property in
                        PropertyCardView(property: property)
                    }
                }
            }
            .toolbar {
                AppToolbar(
                    options: viewModel.options,
                    onAdd: {}
                )
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    //        .toolbar {
    //            AppToolbar(
    //                options: viewModel.options,
    //                onAdd: { viewModel.addProperty() }
    //            )
    //        }
}

enum PropertiesPreviewData {
    static func makeContainer() -> ModelContainer {
        let schema = Schema([
            Property.self, Owner.self, Tenant.self, Contract.self,
            Payment.self, Expenses.self, Ticket.self
            // inclua aqui também o modelo de manutenção (MaintenceModel.swift),
            // se o Property tiver relação com ele
        ])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        
        do {
            let container = try ModelContainer(for: schema, configurations: [config])
            insertSamples(into: container.mainContext)
            return container
        } catch {
            fatalError("Falha ao criar container do preview: \(error)")
        }
    }
    
    private static func insertSamples(into context: ModelContext) {
        let samplePhotoData = UIImage(systemName: "house.fill")?.pngData()
        
        let house = Property(
            title: "Casa 1",
            type: .home,
            area: 32,
            paymentDay: 10,
            isPaid: true,
            street: "Rua Ipê Amarelo",
            number: "55",
            city: "São Paulo",
            profit: 1200.0
        )
        
        let apartment = Property(
            title: "Apto 202",
            type: .apartment,
            area: 58,
            paymentDay: 5,
            isPaid: false,
            street: "Av. Paulista",
            number: "1000",
            city: "São Paulo",
            profit: 2800.0
        )
        
        context.insert(house)
        context.insert(apartment)
    }
}

#Preview {
    PropertiesView()
        .modelContainer(PropertiesPreviewData.makeContainer())
        .environment(AppleAuthManager())
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

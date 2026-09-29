import SwiftUI

struct PropertiesCoordinatorView: View {
    
    @State private var propertiesCoordinator = PropertiesCoordinator()
    @State private var propertiesViewModel = PropertiesViewModel()
    
    
    var body: some View {
        NavigationStack(path: $propertiesCoordinator.path) {
            
            // puxa a tela inicial
            PropertiesView()
                .environment(propertiesCoordinator)
                .environment(propertiesViewModel)
            
            // roteador de pilha
            .navigationDestination(for: PropertiesRoute.self) { route in
                switch route {
                case .details(let id):
                    // PropertyDetailsView(propertyId: id)
                    Text("Detalhes do imóvel \(id)")
                    
                case .newProperty:
                    NewPropertyView()
                }
            }
            
            // roteador de sheets
//            .sheet(item: $propertiesCoordinator.activeSheet) { sheet in
//                switch sheet {
//                case .addProperty:
//                    // AddPropertyView()
//                    Text("Tela de adicionar imóvel")
//                }
//            }
        }
        
//        .navigationBarTitleDisplayMode(.inline) // sem .navigationTitle
//        .toolbar {
//            AppToolbar(
//                onMore: { viewModel.showOptions() },
//                onAdd: { viewModel.addProperty() }
//            )
//        }

    }
}

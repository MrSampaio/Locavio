import SwiftUI
import SwiftData
struct PropertiesCoordinatorView: View {
    @Environment(\.modelContext) private var modelContext
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
                    case .details(let property):
                        PropertyDetailView(
                            property: property,
                            onShowLastPayments: {
                                propertiesCoordinator.pushToLastPayments(property: property)
                            },
                            onDelete: {
                                delete(property)
                            }
                        )

                    case .lastPayments(let property):
                        RecentPaymentsView(property: property)
                    }
                }
            .sheet(item: $propertiesCoordinator.activeSheet) { sheet in
                switch sheet {
                case .addProperty:
                    NewPropertySheet()
                }
            }
        }
        
//        .navigationBarTitleDisplayMode(.inline) // sem .navigationTitle
//        .toolbar {
//            AppToolbar(
//                onMore: { viewModel.showOptions() },
//                onAdd: { viewModel.addProperty() }
//            )
//        }

    }
    
    private func delete(_ property: Property) {
        // sai da tela antes de apagar, para ela não ler um imóvel já removido
        propertiesCoordinator.pop()

        DispatchQueue.main.async {
            do {
                try propertiesViewModel.deleteProperty(property: property, context: modelContext)
            } catch {
                print("Erro ao apagar imóvel: \(error)")
            }
        }
    }
}

//
//  PropertiesCoordinator.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//


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
                            onEdit: {
                                propertiesCoordinator.pushToEditProperty(property: property)
                            },
                            onShowLastPayments: {
                                propertiesCoordinator.pushToLastPayments(property: property)
                            },
                            onDelete: {
                                delete(property)
                            }
                        )

                    case .lastPayments(let property):
                        RecentPaymentsView(property: property)

                    case .editProperty(let property):
                        EditPropertyView(
                            property: property,
                            onEditExpenses: {
                                // TODO: abrir a tela de despesas do imóvel
                            }
                        )
                        .environment(propertiesViewModel)
                    }
                }
            .sheet(item: $propertiesCoordinator.activeSheet) { sheet in
                switch sheet {
                case .addProperty:
                    NewPropertySheet()
                }
            }
        }
        
    }
    
    private func delete(_ property: Property) {
        // sai da tela antes de apagar, para ela não ler um imóvel já removido
        propertiesCoordinator.pop()

        DispatchQueue.main.async {
            propertiesViewModel.deleteProperty(property: property, context: modelContext)
        }
    }
}

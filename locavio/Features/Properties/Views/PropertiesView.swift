//
//  PropertiesView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 26/09/26.
//

import SwiftUI
import SwiftData
import TipKit

struct PropertiesView: View {
    
    @Environment(PropertiesCoordinator.self) private var coordinator
    @Environment(AppleAuthManager.self) private var authManager
    @Environment(\.modelContext) private var context
    
    @State private var viewModel = PropertiesViewModel()
    
    // as dicas desta tela aparecem em sequência: primeiro a do botão "+", depois a do filtro.
    // a próxima só aparece depois que a anterior for dispensada
    @State private var tipGroup = TipGroup(.ordered) {
        AddPropertyTip()
        PropertyStatusTip()
    }
    
    @Query private var properties: [Property]
    @Query private var users: [Owner]
    
    private var visibleProperties: [Property] {
        viewModel.visibleProperties(from: properties)
    }
    
    // true enquanto o iCloud está trazendo dados pro aparelho
    private var isSyncing: Bool {
        authManager.isSyncingFromCloud
    }
    
    // dica atual de cada elemento. ficam separadas pra não pesar o type-check do body
    private var addTip: AddPropertyTip? {
        tipGroup.currentTip as? AddPropertyTip
    }
    
    private var statusTip: PropertyStatusTip? {
        tipGroup.currentTip as? PropertyStatusTip
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                
                SearchBarView(text: $viewModel.searchText)
                
                filterPicker
                
                content
            }
            .animation(.default, value: isSyncing)
            .ignoresSafeArea(.keyboard)
            .scrollDismissesKeyboard(.interactively)
            .toolbar {
                AppToolbar(
                    options: viewModel.options,
                    onAdd: { coordinator.presentAddProperty() },
                    tip: addTip
                )
            }
            .padding(.horizontal)
        }
        .dismissKeyboardOnTap()
        .scrollEdgeEffectStyle(.soft, for: .bottom)
        .scrollIndicators(.hidden)
        .background(Color.appBg)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Apagar Imóvel", isPresented: $viewModel.showDeleteAlert, presenting: viewModel.propertyToDelete) { property in
            Button("Cancelar", role: .cancel) {
                viewModel.propertyToDelete = nil
            }
            Button("Apagar", role: .destructive) {
                viewModel.deleteProperty(property: property, context: context)
                viewModel.propertyToDelete = nil
            }
        } message: { property in
            Text(deleteMessage(for: property))
        }
    }
    
    // MARK: - Partes da tela
    
    private var header: some View {
        HStack(spacing: 12) {
            Text("Imóveis")
                .font(.largeTitle.bold())
            
            // já tem imóveis na tela e o iCloud ainda está trazendo mais: indicador discreto ao lado do título
            if isSyncing && !properties.isEmpty {
                ProgressView()
                    .transition(.opacity)
            }
        }
    }
    
    private var filterPicker: some View {
        Picker("Filtro", selection: $viewModel.filter) {
            ForEach(PropertyFilter.allCases) { filter in
                Text(filter.displayTitle).tag(filter)
            }
        }
        .pickerStyle(.segmented)
        .popoverTip(statusTip)
    }
    
    @ViewBuilder
    private var content: some View {
        if properties.isEmpty && isSyncing {
            syncingState
            
        } else if properties.isEmpty {
            
            // Cenário 1: Não há NENHUM imóvel cadastrado no aplicativo
            PropertiesEmptyStateView(
                isSearchFilterEmpty: false
            )
            .padding(.top, 60) // Empurra para o centro da tela
            
        } else if visibleProperties.isEmpty {
            
            // Cenário 2: Tem imóveis, mas a busca/filtro não encontrou nada
            PropertiesEmptyStateView(
                isSearchFilterEmpty: true
            )
            .padding(.top, 60) // Empurra para o centro da tela
            
        } else {
            propertiesList
        }
    }
    
    // Cenário 0: ainda não chegou nenhum imóvel, mas o iCloud está sincronizando.
    // mostra "carregando" em vez de "nenhum imóvel" pra não parecer que os dados sumiram
    private var syncingState: some View {
        VStack(spacing: 12) {
            ProgressView()
                .controlSize(.large)
            
            Text("Buscando seus imóveis...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
    
    // Cenário 3: Mostra a lista normalmente
    private var propertiesList: some View {
        LazyVStack(spacing: 16) {
            ForEach(visibleProperties) { property in
                propertyRow(property)
            }
        }
    }
    
    private func propertyRow(_ property: Property) -> some View {
        Button {
            coordinator.pushToDetails(property: property)
        } label: {
            PropertyCardView(property: property)
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button {
                coordinator.pushToEditProperty(property: property)
            } label: {
                Label("Editar", systemImage: "pencil")
            }
            
            Button(role: .destructive) {
                viewModel.propertyToDelete = property
                viewModel.showDeleteAlert = true
            } label: {
                Label("Apagar imóvel", systemImage: "trash")
            }
        }
    }
    
    private func deleteMessage(for property: Property) -> String {
        let title = property.title ?? String(localized: "Sem título")
        return String(localized: "Tem certeza que deseja apagar o imóvel '\(title)'? Todos os dados, contratos e chamados vinculados a ele serão perdidos. Essa ação não pode ser desfeita.")
    }
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
        let house = Property(
            title: "Casa 1",
            type: .home,
            area: 32,
            paymentDay: 10,
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
    NavigationStack {
        PropertiesView()
    }
    .modelContainer(PropertiesPreviewData.makeContainer())
    
    .environment(PropertiesCoordinator())
    .environment(AppleAuthManager())
}

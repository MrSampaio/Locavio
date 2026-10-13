//
//  EditPropertyExpensesView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 13/10/26.
//

import SwiftUI
import SwiftData

struct EditPropertyExpensesView: View {

    let property: Property

    @State private var viewModel: ExpensesViewModel

    init(property: Property) {
        self.property = property
        _viewModel = State(initialValue: ExpensesViewModel(property: property))
    }

    var body: some View {
        Form {
            Section("Despesas do imóvel") {
                ExpensesTextFieldCard(viewModel: viewModel)
            }
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Despesas")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Property.self,
        Expenses.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    let property = Property()

    NavigationStack {
        EditPropertyExpensesView(property: property)
    }
    .modelContainer(container)
}

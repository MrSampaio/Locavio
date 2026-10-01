//
//  ExpensesCardView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 01/10/26.
//

import SwiftUI
import SwiftData

struct ExpensesCardView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: ExpensesViewModel
    
    init(property: Property) {
        _viewModel = State(initialValue: ExpensesViewModel(property: property))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
            
            if viewModel.isExpanded {
                content
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
    
    // MARK: - Cabeçalho (Valor total)
    
    private var header: some View {
        Button {
            withAnimation(.snappy) { viewModel.toggle() }
        } label: {
            HStack(spacing: 8) {
                Text(viewModel.totalLabel)
                    .font(.title3)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Text(viewModel.totalText)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.secondary)
                
                Image(systemName: "chevron.down")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.accentColor)
                    .rotationEffect(.degrees(viewModel.isExpanded ? 0 : -90))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Lista
    
    private var content: some View {
        VStack(spacing: 0) {
            if viewModel.rows.isEmpty {
                Text(viewModel.emptyText)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
            } else {
                ForEach(viewModel.rows) { row in
                    expenseRow(row)
                }
            }
            
            
        }
        .background(.quaternary)
    }
    
    private func expenseRow(_ row: ExpenseRow) -> some View {
        HStack {
            Text(row.title)
                .font(.title3)
                .foregroundStyle(.primary)
                .lineLimit(1)
            
            Spacer(minLength: 12)
            
            Text(row.valueText)
                .font(.title3)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .contentShape(Rectangle())
        .contextMenu {
            Button(role: .destructive) {
                viewModel.delete(row.id, in: modelContext)
            } label: {
                Label("Remover", systemImage: "trash")
            }
        }
    }
}


#Preview {
    let container = try! ModelContainer(
        for: Property.self, Owner.self, Tenant.self, Contract.self,
             Payment.self, Expenses.self, Ticket.self, Maintence.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    let property = Property(title: "Casa 1")
    container.mainContext.insert(property)

    for (title, value) in [("IPTU", 200.0), ("Condomínio", 400), ("Seguro", 200), ("Lucro", 400)] {
        container.mainContext.insert(Expenses(property: property, title: title, value: value))
    }

    return ExpensesCardView(property: property)
        .padding()
        .modelContainer(container)
}

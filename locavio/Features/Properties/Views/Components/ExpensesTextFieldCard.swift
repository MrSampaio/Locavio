//
//  ExpensesTextFieldCard.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 07/10/26.
//

import SwiftUI
import SwiftData

struct ExpensesTextFieldCard: View {
    
    @Environment(\.modelContext) private var context
    @Environment(ExpensesViewModel.self) private var viewModel
    
    private let property: Property
    
    @State private var expenses: [Expenses]
    @State private var newExpenseName = ""
    @State private var newExpenseValue: Double?
    
    init(property: Property, expenses: [Expenses]) {
        self.property = property
        _expenses = State(initialValue: expenses)
    }
    
    private var isButtonDisabled: Bool {
        if !(newExpenseName.trimmingCharacters(in: .whitespaces).isEmpty) && !(newExpenseValue == nil) {
            return false
        } else {
            return true
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
            
            if viewModel.isExpanded {
                VStack(spacing: 10) {
                    ForEach($expenses) { $expense in
                        line(expense: expense)
                    }
                    
                    newExpenseLine
                }
                .padding(.top, 24)
                .transition(.opacity)
                .clipped()
            }
        }
        .padding(20)
        .background(.background, in: RoundedRectangle(cornerRadius: 24))
        .padding()
        .onAppear {
            viewModel.property = property
            viewModel.property.expenses = expenses
        }
    }
    
    @ViewBuilder
    private var header: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.1)) {
                viewModel.toggle()
            }
        } label: {
            HStack {
                Image(systemName: "creditcard")
                    .foregroundStyle(.accent)
                
                Text("Valor das despesas")
                
                Spacer()
                
                if viewModel.totalExpenses == 0 {
                    Text("Insira aqui")
                        .foregroundStyle(.secondary)
                } else {
                    Text(viewModel.totalExpenses, format: .currency(code: "BRL"))
                }
                
                Image(systemName: "chevron.down")
                    .fontWeight(.semibold)
                    .foregroundStyle(.accent)
                    .rotationEffect(.degrees(viewModel.isExpanded ? 0 : -90))
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private func line(expense: Expenses) -> some View {
        HStack(spacing: 10) {
            Button {
                viewModel.delete(expense.persistentModelID, in: context)
                expenses = viewModel.property.expenses ?? []
            } label: {
                circleIcon(iconName: "minus.circle.fill", color: .red)
            }
            .buttonStyle(.plain)
            
            Text(expense.title ?? "")
            
            Spacer()
            
            Text(expense.value ?? Double(), format: .currency(code: "BRL"))
        }
    }
    
    @ViewBuilder
    private var newExpenseLine: some View {
        HStack(spacing: 10) {
            Button{
                viewModel.newTitle = newExpenseName
                viewModel.newValueText = String(newExpenseValue ?? Double())
                
                if viewModel.canAdd {
                    viewModel.addExpense(in: context)
                    expenses = viewModel.property.expenses ?? []
                    newExpenseName = ""
                    newExpenseValue = nil
                }
            } label: {
                circleIcon(iconName: "plus.circle.fill", color: .green)
            }
            .buttonStyle(.plain)
            .disabled(isButtonDisabled)
            
            TextField("Título", text: $newExpenseName)
            
            TextField("Valor", value: $newExpenseValue, format: .currency(code: "BRL"))
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
        }
    }
    
    @ViewBuilder
    private func circleIcon(iconName: String, color: Color) -> some View {
        Image(systemName: iconName)
            .symbolRenderingMode(.palette)
            .foregroundStyle(.white, color)
            .frame(width: 32, height: 32)
    }
}

#Preview {
    
    let container = try! ModelContainer(
        for: Property.self, Expenses.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    
    let property = Property()
    container.mainContext.insert(property)
    
    let iptu = Expenses(property: property, title: "IPTU", value: 345, date: Date())
    let condominio = Expenses(property: property, title: "Condomínio", value: 120, date: Date())
    container.mainContext.insert(iptu)
    container.mainContext.insert(condominio)
    
    return ExpensesTextFieldCard(property: property, expenses: property.expenses ?? [])
        .environment(ExpensesViewModel())
        .modelContainer(container)
}


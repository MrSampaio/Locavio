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
    
    let viewModel: ExpensesViewModel
    
    @State private var newExpenseName = ""
    @State private var newExpenseValueText = ""
    
    @FocusState private var isFocused: Bool
    
    private var isButtonDisabled: Bool {
        if !(newExpenseName.trimmingCharacters(in: .whitespaces).isEmpty) && !(newExpenseValueText.trimmingCharacters(in: .whitespaces).isEmpty) {
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
                    ForEach(viewModel.expenses) { expense in
                        line(expense: expense)
                    }
                    
                    newExpenseLine
                }
                .padding(.top, 24)
                .transition(.opacity)
                .clipped()
            }
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
                viewModel.delete(expense, context: context)
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
                viewModel.newValueText = newExpenseValueText
                
                if viewModel.canAdd {
                    viewModel.addExpense(context: context)
                    newExpenseName = ""
                    newExpenseValueText = ""
                }
            } label: {
                circleIcon(iconName: "plus.circle.fill", color: .green)
            }
            .buttonStyle(.plain)
            .disabled(isButtonDisabled)
            
            TextField("Título", text: $newExpenseName)
            
            TextField("Valor", text: $newExpenseValueText)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .focused($isFocused)
                .onChange(of: isFocused) { _, isNowFocused in
                    if !isNowFocused {
                        var cleanText = newExpenseValueText.replacingOccurrences(of: ".", with: "")
                        cleanText = cleanText.replacingOccurrences(of: ",", with: ".")
                        cleanText = cleanText.filter { $0.isNumber || $0 == "." }
                        
                        if let value = Double(cleanText) {
                            newExpenseValueText = value.formatted(.currency(code: "BRL"))
                        }
                    } else if isNowFocused {
                        formatAsDouble()
                    }
                }
        }
    }
    
    private func formatAsDouble() {
        var cleaned = newExpenseValueText.replacingOccurrences(of: ".", with: "")
        newExpenseValueText = cleaned.filter { $0.isNumber || $0 == "," }
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
    ExpensesTextFieldCard(viewModel: ExpensesViewModel())
        .modelContainer(for: Expenses.self, inMemory: true)
}


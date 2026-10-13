//
//  PropertyFinancialSection.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 12/10/26.
//


import SwiftUI

/// A linha de despesas é diferente em cada tela, então entra como parâmetro.
struct PropertyFinancialSection<ExpensesRow: View>: View {

    @Environment(PropertiesViewModel.self) private var viewModel
    @Environment(\.colorScheme) private var colorScheme

    private let expensesTotal: Double
    private let expensesRow: () -> ExpensesRow

    init(expensesTotal: Double, @ViewBuilder expensesRow: @escaping () -> ExpensesRow) {
        self.expensesTotal = expensesTotal
        self.expensesRow = expensesRow
    }

    /// O Picker lê e grava direto no draft: uma única fonte de verdade para o dia de pagamento
    private var paymentDay: Binding<Int> {
        Binding(
            get: { Int(viewModel.propertyDraft.payday) ?? 1 },
            set: { viewModel.setValueToPropertyDraft(String($0), propertyFieldType: .payday) }
        )
    }

    var body: some View {
        Section {
            expensesRow()

            PropertyLabeledContent(textPropertyLabel: "Lucro", iconPropertyLabel: "chart.line.uptrend.xyaxis", textFieldPlaceholder: "Insira um valor", textFieldHasUnit: false, textFieldIsNumber: true, textFieldType: .profit, isRequired: true)

            Picker(selection: paymentDay) {
                ForEach(1..<32) { day in
                    Text(String(day)).tag(day)
                }
            } label: {
                Label {
                    Text("Dia de Pagamento")
                } icon: {
                    Image(systemName: "calendar")
                        .font(.subheadline)
                        .foregroundStyle(.accent)
                }
            }
            .pickerStyle(.menu)
        } header: {
            Text("Financeiro")
        } footer: {
            HStack {
                Text("Total do Aluguel")
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .font(.body)

                Spacer()

                Text(viewModel.calcTotalRent(totalValueExpenses: expensesTotal), format: .currency(code: "BRL"))
                    .font(.headline)
                    .foregroundStyle(.accent)
            }
            .padding(.vertical, 24)
            .listRowInsets(EdgeInsets())
        }
    }
}

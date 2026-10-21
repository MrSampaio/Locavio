//
//  DashboardFilters.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 02/10/26.
//

import Foundation

enum DashboardPeriod: String, CaseIterable, Identifiable {
    case oneMonth = "1 mês"
    case sixMonths = "6 meses"
    case oneYear = "1 ano"
    
    var id: Self { self }

    var displayTitle: String {
        switch self {
        case .oneMonth: String(localized: "1 mês")
        case .sixMonths: String(localized: "6 meses")
        case .oneYear: String(localized: "1 ano")
        }
    }
}

enum SegmentedDashboard: String, CaseIterable, Identifiable {
    case profits = "Lucro"
    case expenses = "Despesa"
    
    var id: Self { self }

    var displayTitle: String {
        switch self {
        case .profits: String(localized: "Lucro")
        case .expenses: String(localized: "Despesa")
        }
    }
}

enum ExpensesValueType: CaseIterable, Identifiable {
    case totalExpensePlusMaintence
    case maintence
    case expenses
    
    var id: Self { self }
}

//
//  DashboardViewModel.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 01/10/26.
//

import Foundation

@Observable
class DashboardViewModel {
    
    var currentFilter: SegmentedDashboard = .profits
    var currentDashPeriod: DashboardPeriod = .oneMonth
    var properties: [Property] = []
    
    func totalSum(expenseValueType: ExpensesValueType = .totalExpensePlusMaintence) -> Double {
        monthlyChartData(expenseValueType: expenseValueType).reduce(0) { $0 + $1.total }
    }
    
    var hasChartData: Bool {
        switch currentFilter {
        case .profits: !getPayments().isEmpty
        case .expenses: !getExpenses().isEmpty || !getMaintenceValues().isEmpty
        }
    }
    
    var chartTitle: String {
        switch currentFilter {
        case .profits:
            switch currentDashPeriod {
            case .oneMonth: "Lucro mensal"
            case .sixMonths: "Lucro semestral"
            case .oneYear: "Lucro anual"
            }
        case .expenses:
            switch currentDashPeriod {
            case .oneMonth: "Despesa mensal"
            case .sixMonths: "Despesa semestral"
            case .oneYear: "Despesa anual"
            }
        }
    }
    
    func monthlyChartData(expenseValueType: ExpensesValueType = .totalExpensePlusMaintence) -> [MonthlyTotal] {
        
        let months = lastMonths(monthCount)
        
        switch currentFilter {
        case .profits: return monthlyTotals(items: getPayments(), months: months)
        case .expenses:
            switch expenseValueType {
            case .totalExpensePlusMaintence:
                let expenses = monthlyTotals(items: getExpenses(), months: months)
                let maintences = monthlyTotals(items: getMaintenceValues(), months: months)
                
                return zip(expenses, maintences).map {
                    MonthlyTotal(month: $0.month, total: $0.total + $1.total)
                }
            case .maintence:
                return monthlyTotals(items: getMaintenceValues(), months: months)
            case .expenses:
                return monthlyTotals(items: getExpenses(), months: months)
            }
        }
    }
    
    var monthCount: Int {
        switch currentDashPeriod {
        case .oneMonth: 1
        case .sixMonths: 6
        case .oneYear: 12
        }
    }
    
    func lastMonths(_ count: Int) -> [Date] {
        let calendar = Calendar.current
        guard let current = getStartOfMonth(.now) else { return [] }
        
        return (0 ..< count)
            .reversed()
            .compactMap { calendar.date(byAdding: .month, value: -$0, to: current) }
    }
    
    func monthlyTotals<T: DatedValue>(items: [T], months: [Date]) -> [MonthlyTotal] {
        var totals: [Date: Double] = [:]
        
        for item in items {
            guard let date = item.date,
                  let value = item.value,
                  let monthStart = getStartOfMonth(date)
            else { continue }
            
            totals[monthStart, default: 0] += value
        }
        
        return months.map { month in
            MonthlyTotal(month: month, total: totals[month, default: 0])
        }
    }
    
    func countReceivedRent() -> Int {
        let propertyWithTenant = properties.filter{ $0.tenant != nil }
        return propertyWithTenant.filter(\.isPaid).count
    }
    
    func countNotReceivedRent() -> Int {
        let propertyWithTenant = properties.filter{ $0.tenant != nil }
        return propertyWithTenant.filter { !$0.isPaid }.count
    }
    
    func getStartOfMonth(_ date: Date) -> Date? {
        Calendar.current.dateInterval(of: .month, for: date)?.start
    }
    
    func getPayments() -> [Payment] {
        
        var allPayments: [Payment] = []
        
        for property in properties {
            if let payments = property.payments {
                for payment in payments {
                    allPayments.append(payment)
                }
            }
        }
        
        return allPayments
    }
    
    func getExpenses() -> [Expenses] {
        var allExpenses: [Expenses] = []
        
        for property in properties {
            if let expenses = property.expenses {
                for expense in expenses {
                    allExpenses.append(expense)
                }
            }
        }
        
        return allExpenses
    }
    
    func getMaintenceValues() -> [Maintence] {
        var allMaintence: [Maintence] = []
        var allTickets: [Ticket] = []
        
        for property in properties {
            if let tickets = property.tickets {
                for ticket in tickets {
                    allTickets.append(ticket)
                }
            }
        }
        
        for ticket in allTickets {
            for maintence in ticket.maintence ?? [] {
                allMaintence.append(maintence)
            }
        }
        
        return allMaintence
    }
}

//
//  DashboardViewModel.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 01/10/26.
//

import Foundation

enum DashboardPeriod: String, CaseIterable, Identifiable {
    case oneMonth = "1 mês"
    case sixMonths = "6 meses"
    case oneYear = "1 ano"
    
    var id: Self { self }
}

enum SegmentedDashboard: String, CaseIterable, Identifiable {
    case profits = "Lucro"
    case expenses = "Despesa"
    
    var id: Self { self }
}

@Observable
class DashboardViewModel {
    
    var currentFilter: SegmentedDashboard = .profits
    var currentDashPeriod: DashboardPeriod = .oneMonth
    var properties: [Property] = []
    
    var totalSum: Double {
        switch currentFilter {
        case .profits:
            sumTotal(items: getPayments(), dashPeriod: currentDashPeriod)
        case .expenses:
            sumTotal(items: getExpenses(), dashPeriod: currentDashPeriod)
        }
    }
    
    func sumTotal<T: DatedValue> (items: [T], dashPeriod: DashboardPeriod) -> Double {
        let startDate: Date = getStartDay(period: dashPeriod) ?? Date.now
        let endDate = Date.now
        
        let filteredItems = filterByRangeOfDate(items: items, startDate: startDate, endDate: endDate)
        
        var sum: Double = 0.0
        
        let itemsToSum: [Double] = filteredItems.map{ $0.value ?? 0 }
        
        for item in itemsToSum {
            sum += item
        }
        
        return sum
    }
    
    func countReceivedRent() -> Int {
        let propertiesRentReceived: [Property] = properties.filter { $0.isPaid == true }
        
        return propertiesRentReceived.count
    }
    
    func countNotReceivedRent() -> Int {
        let propertiesNotReceivedRent: [Property] = properties.filter { $0.isPaid == false || $0.isPaid == nil }
        
        return propertiesNotReceivedRent.count
    }
    
    func getStartDay(period: DashboardPeriod) -> Date? {
        var startPeriodValue = 0
        let periodType: Calendar.Component
        
        switch period {
        case .oneMonth:
            startPeriodValue = 1
            periodType = .month
        case .sixMonths:
            startPeriodValue = 6
            periodType = .month
        case .oneYear:
            startPeriodValue = 1
            periodType = .year
        }
        
        return Calendar.current.date(byAdding: periodType, value: -startPeriodValue, to: .now)
    }
    
    func filterByRangeOfDate<T: DatedValue>(items: [T], startDate: Date, endDate: Date) -> [T] {
        
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: startDate)
        guard let endNextDay = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: endDate)) else { return [] }
        
        let interval = DateInterval(start: start, end: endNextDay)
        
        return items.filter {
            guard let itemDate = $0.date else { return false }
            return interval.contains(itemDate)
        }
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
}

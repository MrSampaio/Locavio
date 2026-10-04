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
    var currentDashPeriod: DashboardPeriod = .sixMonths
    var properties: [Property] = []
    
    var totalSum: Double {
        switch currentFilter {
        case .profits:
            sumTotal(items: getPayments(), dashPeriod: currentDashPeriod)
        case .expenses:
            sumTotal(items: getExpenses(), dashPeriod: currentDashPeriod)
        }
    }
    
    var chartTitle: String {
        switch currentFilter {
        case .profits: "Lucro mensal"
        case .expenses: "Despesa mensal"
        }
    }
    
    var monthlyChartData: [MonthlyTotal] {
        
        let months = lastMonths(monthCount)
        
        switch currentFilter {
        case .profits: return monthlyTotals(items: getPayments(), months: months)
        case .expenses: return monthlyTotals(items: getExpenses(), months: months)
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
        
        return (0..<count)
            .reversed()
            .compactMap { calendar.date(byAdding: .month, value: -$0, to: current) }
            .compactMap { getStartOfMonth($0) }
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
    
    func getStartOfMonth(_ date: Date) -> Date? {
        Calendar.current.dateInterval(of: .month, for: date)?.start
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

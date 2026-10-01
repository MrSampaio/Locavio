//
//  DashboardViewModel.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 01/10/26.
//

import Foundation

@Observable
class DashboardViewModel {
    
    func sumTotalBruteProfit(payments: [Payment], dashPeriod: DashboardPeriod) -> Double {
        let startDate: Date = getStartDay(period: dashPeriod) ?? Date.now
        let endDate = Date.now
        
        let filteredPayments = filterByRangeOfDate(items: payments, startDate: startDate, endDate: endDate)
        
        var sum: Double = 0.0
        
        let profits: [Double] = filteredPayments.map{ $0.value ?? 0 }
        
        for profit in profits {
            sum += profit
        }
        
        return sum
    }
    
    func sumTotalBruteExpense(expenses: [Expenses], dashPeriod: DashboardPeriod) -> Double {
        var sum: Double = 0.0
        
        let expenses: [Double] = expenses.map { $0.value ?? 0 }
        
        for expense in expenses {
            sum += expense
        }
        
        return sum
    }
    
    func countReceivedRent(properties: [Property]) -> Int {
        let propertiesRentReceived: [Property] = properties.filter { $0.isPaid == true }
        
        return propertiesRentReceived.count
    }
    
    func countNotReceivedRent(properties: [Property]) -> Int {
        let propertiesNotReceivedRent: [Property] = properties.filter { $0.isPaid == false }
        
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
}

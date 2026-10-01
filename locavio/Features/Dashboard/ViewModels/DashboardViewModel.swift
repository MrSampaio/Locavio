//
//  DashboardViewModel.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 01/10/26.
//

import Foundation

@Observable
class DashboardViewModel {
    
    func sumTotalBruteProfit(payments: [Payment]) -> Double {
        var sum: Double = 0.0
        
        let profits: [Double] = payments.map{ $0.value ?? 0 }
        
        for profit in profits {
            sum += profit
        }
        
        return sum
    }
    
    func sumTotalBruteExpense(expenses: [Expenses]) -> Double {
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
}

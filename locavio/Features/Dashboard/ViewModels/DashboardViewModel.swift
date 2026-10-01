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
}

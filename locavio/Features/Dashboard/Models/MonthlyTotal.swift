//
//  MonthlyTotal.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 02/10/26.
//

import Foundation

struct MonthlyTotal: Identifiable {
    let month: Date
    let total: Double
    var id: Date { month }
}

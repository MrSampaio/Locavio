//
//  ExpensesFormData.swift
//  locavio
//
//  Created by Julio Sampaio on 03/10/26.
//

import Foundation

struct ExpenseFormData {
    
    // caso seja nulo, significa que é uma nova despesa
    // caso esteja preenchido, significa que será editada
    var existingExpense: Expenses?
    
    var title: String
    var value: String
    var date: Date
}

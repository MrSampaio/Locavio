//
//  ExpensesModel.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftData

@Model
final class Expenses: Identifiable {
    var property: Property?
    var title: String?
    var value: Double?
    
    init(property: Property? = nil, title: String? = nil, value: Double? = nil) {
        self.property = property
        self.title = title
        self.value = value
    }
}

//
//  PaymentModel.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftData

@Model
final class Payment: Identifiable{
    var date: Date?
    var property: Property?
    var value: Double?
    var proof: Data?
    
    init(date: Date? = nil, property: Property? = nil, value: Double? = nil, proof: Data? = nil) {
        self.date = date
        self.property = property
        self.value = value
        self.proof = proof
    }
}

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
    var proof: Data?
    
    init(date: Date? = nil, property: Property? = nil, proof: Data? = nil) {
        self.date = date
        self.property = property
        self.proof = proof
    }
}

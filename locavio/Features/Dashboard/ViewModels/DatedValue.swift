//
//  DatedValue.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 01/10/26.
//

import Foundation

protocol DatedValue {
    var date: Date? { get }
    var value: Double? { get }
}

extension Payment: DatedValue {}

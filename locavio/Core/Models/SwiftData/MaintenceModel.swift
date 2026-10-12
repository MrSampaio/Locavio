//
//  MaintenceModel.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftData

@Model
final class Maintence: Identifiable {
    var ticket: Ticket?
    var item: String?
    var value: Double?
    
    init(ticket: Ticket? = nil, item: String? = nil, value: Double? = nil) {
        self.ticket = ticket
        self.item = item
        self.value = value
    }
}

//
//  BadgeColor.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 01/10/26.
//
import SwiftUI

struct TagBadgeItem: Identifiable {
    let text: String
    let color: Color
    var id: String { text }
}


enum BadgeColor {
    static let rented = Color("Badget01")
    static let propertyType = Color.accent
    static let notRented = Color("Badget03")
    static let area = Color("Badget04")
}



//property
extension PropertyType {
    
    var badgeColor: Color { BadgeColor.propertyType }
}
 
extension Property {
    
    var tenantBadge: TagBadgeItem {
        tenant != nil
            ? TagBadgeItem(text: "Alugado", color: BadgeColor.rented)
            : TagBadgeItem(text: "Não alugado", color: BadgeColor.notRented)
    }
 
    
    var typeBadge: TagBadgeItem? {
        guard let type else { return nil }
        return TagBadgeItem(text: type.rawValue, color: type.badgeColor)
    }
 
    
    var areaBadge: TagBadgeItem? {
        guard let area else { return nil }
        return TagBadgeItem(text: "\(area)m²", color: BadgeColor.area)
    }
}

//ticket
extension TicketStats {
    var badgeText: String {
        switch self {
        case .open:      return "Aberto"
        case .completed: return "Concluído"
        }
    }
 
    var badgeColor: Color {
        switch self {
        case .open:return Color(.accent)
        case .completed: return Color(BadgeColor.rented)
        }
    }
}

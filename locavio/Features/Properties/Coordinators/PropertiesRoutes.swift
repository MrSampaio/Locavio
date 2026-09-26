//
//  PropertiesRoutes.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation

// rotas de empilhamento (NavigationStack)
enum PropertiesRoute: Hashable {
    case details(propertyId: UUID)
    case newProperty
}

// rotas de sheets
enum PropertiesSheet: String, Identifiable {
    case addProperty
    
    var id: String { self.rawValue }
}

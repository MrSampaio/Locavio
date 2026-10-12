//
//  ProfileRoutes.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftData


enum ProfileRoutes{
    case terms
    case privacy
}

enum ProfileSheet: Identifiable {
    case editProfileSheet(Owner)
    
    var id: String {
        switch self {
            case .editProfileSheet(let owner):
                return "editProfileSheet_\(owner.persistentModelID)"
        }
    }
}

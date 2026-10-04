//
//  ProfileRoutes.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation


enum ProfileRoutes{
    case terms
    case privacy
}

enum ProfileSheet: Identifiable{
    case editProfileSheet
    
    var id: String {
        switch self {
            case .editProfileSheet:
                return "editProfileSheet"
        }
    }
}

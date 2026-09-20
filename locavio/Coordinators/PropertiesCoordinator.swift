//
//  PropertiesCoordinator.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI

@Observable
final class PropertiesCoordinator {
    
    // pilha de navegação principal
    var path = NavigationPath()
    
    // controle das sheets
    var activeSheet: PropertiesSheet?
    
    // navegação em pilha
    func pushToDetails(propertyId: UUID) {
        path.append(PropertiesRoute.details(propertyId: propertyId))
    }
    
    func pushToNewProperty(){
        path.append(PropertiesRoute.newProperty)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    // navegação das sheets
//    func presentAddProperty() {
//        activeSheet = .addProperty
//    }
    
    func dismissSheet() {
        activeSheet = nil
    }
}

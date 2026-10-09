//
//  TicketsCoordinator.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import Foundation
import SwiftUI

@Observable
final class TicketsCoordinator{
    var path = NavigationPath()

    // controle das sheets
    var activeSheet: TicketsSheet?
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    // navegação das sheets
    func presentAddTicket() {
        activeSheet = .addTicket
    }
    
    
}

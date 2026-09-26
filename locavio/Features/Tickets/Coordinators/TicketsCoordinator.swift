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
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}

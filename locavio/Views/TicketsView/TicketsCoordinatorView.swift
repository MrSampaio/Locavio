//
//  TicketsCoordinatorView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import Foundation
import SwiftUI

struct TicketsCoordinatorView: View {
    @State private var ticketsCoordinator = TicketsCoordinator()
        
    var body: some View {
        NavigationStack(path: $ticketsCoordinator.path) {
            TicketsView()
                .environment(ticketsCoordinator)
        }
    }
}

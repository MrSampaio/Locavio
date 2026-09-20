//
//  DashboardCoordinatorView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import Foundation
import SwiftUI

struct DashboardCoordinatorView: View {
    @State private var dashboardCoordinator = DashboardCoordinator()
        
    var body: some View {
        NavigationStack(path: $dashboardCoordinator.path) {
            DashboardView()
                .environment(dashboardCoordinator)
        }
    }
}

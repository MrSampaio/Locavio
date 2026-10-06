//
//  DashboardCoordinatorView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI
import SwiftData

struct DashboardCoordinatorView: View {
    @Environment(AppleAuthManager.self) private var authManager
    @Environment(\.modelContext) private var modelContext

    @State private var dashboardCoordinator = DashboardCoordinator()

    @Query private var owners: [Owner]

    private var currentOwner: Owner? {
        guard let userID = authManager.currentUserID else {
            return nil
        }

        return owners.first { owner in
            owner.appleUserID == userID
        }
    }

    private var hasNoProperty: Bool {
        currentOwner?.properties?.isEmpty ?? true
    }

    var body: some View {
        NavigationStack(path: $dashboardCoordinator.path) {
            Group {
                if hasNoProperty {
                    DashboardWithNoPropertyView()
                } else {
                    DashboardView()
                }
            }
            .environment(dashboardCoordinator)
        }
    }
}

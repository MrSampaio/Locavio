//
//  locavioApp.swift
//  locavio
//
//  Created by Julio Sampaio on 18/09/26.
//

import SwiftUI
import SwiftData
import AuthenticationServices

@main
struct locavioApp: App {
    @State private var appleAuthManager = AppleAuthManager()
    @State private var dashboardViewModel = DashboardViewModel()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Owner.self,
            Property.self,
            Tenant.self,
            Contract.self,
            Payment.self,
            Expenses.self,
            Ticket.self,
            Maintence.self
        ])
        
        // testa se é preview do canva, NÃO REMOVER EM HIPÓTESE ALGUMA!!!!!!!!!!!
        let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PLAYGROUNDS"] == "1"
        
        // se for Canvas, isStoredInMemoryOnly vira TRUE. Se for o app real, vira FALSE.
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: isPreview)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            Group {
                Group {
                    switch appleAuthManager.currentAuthState {
                        case .authenticated:
                            MainTabView()
                        case .needsRegistration:
                            SignUpView()
                        case .loggedOut:
                            LoginView()
                    }
                }
            }
            .environment(appleAuthManager)
            .environment(dashboardViewModel)
            .onReceive(NotificationCenter.default.publisher(for: ASAuthorizationAppleIDProvider.credentialRevokedNotification)){ _ in
                            print("Credential revoked in real time.")
                            appleAuthManager.logout() //vai alterar o isAuthenticated para false e a tela muda
                        }
                        .task {
                            appleAuthManager.checkCredentialStatus(context: sharedModelContainer.mainContext)
                        }

        }
        
        .modelContainer(sharedModelContainer)
    }
}

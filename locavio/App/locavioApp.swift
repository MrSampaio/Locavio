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
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            Group{
                if appleAuthManager.isAuthenticated {
                    switch appleAuthManager.currentAuthState {
                        case .authenticated:
                            MainTabView()
                        case .needsRegistration:
                            SignUpView()
                            #warning("MUDA PRA SIGN UP VIEW COORDINATOR")
                            
                        case nil:
                            LoginView()
                    }
                }
                else{
                    LoginView()
                }
            }
            
            .environment(appleAuthManager)
            .onReceive(NotificationCenter.default.publisher(for: ASAuthorizationAppleIDProvider.credentialRevokedNotification)){ _ in
                            print("Credential revoked in real time.")
                            appleAuthManager.logout() //vai alterar o isAuthenticated para false e a tela muda
                        }
                        .task {
                            appleAuthManager.checkCredentialStatus() // checa o status toda vez que o app abre
                        }

        }
        
        .modelContainer(sharedModelContainer)
    }
}

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
            Item.self,
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
            LoginView()
            
                // depois ajusta esse onReceive com o KeychainHelper configurado
                .onReceive(NotificationCenter.default.publisher(for: ASAuthorizationAppleIDProvider.credentialRevokedNotification)){
                    _ in
                    print("Credential revoked.")
                    
                    UserDefaults.standard.removeObject(forKey: "appleUserID")
                }
                .task{
                    appleAuthManager.checkCredentialStatus()
                }
        }
        
        .modelContainer(sharedModelContainer)
    }
}

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
    
    @State private var isVideoFinished = false
    
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
                if !isVideoFinished || appleAuthManager.currentAuthState == .loading {
                    
                    SplashView(onFinish: {
                        // Quando o AVPlayer terminar, ele muda o estado com uma transição suave
                        withAnimation(.easeInOut) {
                            isVideoFinished = true
                        }
                    })
                    
                } else {
                    switch appleAuthManager.currentAuthState {
                        case .authenticated:
                            MainTabView()
                        case .needsRegistration:
                            SignUpView()
                        case .loggedOut:
                            LoginView()
                        case .loading:
                            EmptyView()
                    }
                }
            }
            .environment(appleAuthManager)
            .environment(dashboardViewModel)
            .onReceive(NotificationCenter.default.publisher(for: ASAuthorizationAppleIDProvider.credentialRevokedNotification)){ _ in
                print("Credential revoked in real time.")
                // apaga os dados do usuário (como a Apple pede), limpa o Keychain e a tela volta pro login
                appleAuthManager.handleCredentialRevoked(context: sharedModelContainer.mainContext)
            }
            .task {
                appleAuthManager.checkCredentialStatus(context: sharedModelContainer.mainContext)
            }
            
        }
        
        .modelContainer(sharedModelContainer)
    }
}

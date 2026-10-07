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
    @State private var propertiesViewModel = PropertiesViewModel()
    @State private var propertiesCoordinator = PropertiesCoordinator()
    
    @AppStorage("onboardingConcluido") private var onboardingConcluido = false
    
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
                if !isVideoFinished {
                    SplashView(
                        onFinish: {
                            withAnimation(.easeInOut) {
                                isVideoFinished = true
                            }
                        }
                    )
                } else if !onboardingConcluido {
                    OnboardingView()
                } else {
                    NavigationStack {
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
            }
            .environment(appleAuthManager)
            .environment(dashboardViewModel)
            .environment(propertiesCoordinator)
            .environment(propertiesViewModel)
            .onReceive(
                NotificationCenter.default.publisher(
                    for: ASAuthorizationAppleIDProvider.credentialRevokedNotification
                )
            ) { _ in
                print("Credential revoked in real time.")
                
                appleAuthManager.handleCredentialRevoked(
                    context: sharedModelContainer.mainContext
                )
            }
            .task {
                appleAuthManager.checkCredentialStatus(
                    context: sharedModelContainer.mainContext
                )
            }
        }
        .modelContainer(sharedModelContainer)
    }
}



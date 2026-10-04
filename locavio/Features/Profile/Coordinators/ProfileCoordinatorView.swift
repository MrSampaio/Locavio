//
//  ProfileCoordinatorView.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftUI

struct ProfileCoordinatorView: View {
    @State private var profileCoordinator = ProfileCoordinator()
    
    var body: some View {
        NavigationStack(path: $profileCoordinator.path) {
            ProfileView()
                .environment(profileCoordinator)
            
            // roteador de pilha
                .navigationDestination(for: ProfileRoutes.self) { route in
                    switch route {
                        case .terms:
                            TermsOfUseView()
                        case .privacy:
                            PrivacyPolicyView()
                    }
                }
        }
        
       
//        .toolbarBackground(.ultraThinMaterial, for: .tabBar)
        .sheet(item: $profileCoordinator.activeSheet) { sheet in
            switch sheet {
                case .editProfileSheet:
                    EditProfileSheet()
                        .environment(profileCoordinator)
            }
        }
    }
}

//struct PropertiesCoordinatorView: View {
//
//    @State private var propertiesCoordinator = PropertiesCoordinator()
//    @State private var propertiesViewModel = PropertiesViewModel()
//    
//    
//    var body: some View {
//        NavigationStack(path: $propertiesCoordinator.path) {
//            
//            // puxa a tela inicial
//            PropertiesView()
//                .environment(propertiesCoordinator)
//                .environment(propertiesViewModel)
//            
//            // roteador de pilha
//                .navigationDestination(for: PropertiesRoute.self) { route in
//                    switch route {
//                        case .details(let id):
//                            // PropertyDetailsView(propertyId: id)
//                            Text("Detalhes do imóvel \(id)")
//                            
//                        case .newProperty:
//                            NewPropertyView()
//                    }
//                    }

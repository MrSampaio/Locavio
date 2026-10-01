//
//  ProfileView.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    @Environment(ProfileCoordinator.self) private var coordinator
    
    
    // futuras queries
    //    @Query private var userProfiles: [UserProfile]
    //    @Query private var properties: [Property]
    //    @Query private var tenants: [Tenant]
    
    var body: some View {
        ZStack{
            Color(UIColor.appBg)
                .ignoresSafeArea()

            
            VStack(spacing: 13){
                ScrollView(){
                    profileHeader
                    notificationSettings
                    legalSection
                }

            }
            
        }
        
        .navigationTitle("Perfil")
        .navigationBarTitleDisplayMode(.large)
        .toolbar{
            ProfileToolbar(onClick: {})
        }

        
    }
    
    @ViewBuilder
    var profileHeader: some View {
        VStack(alignment: .center){
            ProfileHeader(
                userImage: nil,
                userName: "Julis",
                maskedDocument: "***********",
                numberOfProperties: 10,
                numberOfTenants: 5
            )
        }
    }
    
    @ViewBuilder
    var notificationSettings: some View {
        Form{
            OptionToggle(text: "Notificar Pagamentos", isOn: $viewModel.notifyPayments)
            
            OptionToggle(text: "Notificar Vencimentos", isOn: $viewModel.notifyPendentPayments)
            
            OptionToggle(text: "Notificar Chamados", isOn: $viewModel.notifyTickets)
        }
        .cornerRadius(30)
        .scrollDisabled(true)
        .frame(height: 200)
        .scrollContentBackground(.hidden)
        .background(Color(.appBg))
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    var legalSection: some View {
        Form{
            LegalOption(
                text: "Termos de uso",
                icon: "menucard.fill",
                action: coordinator.pushToTerms
            )
            
            LegalOption(
                text: "Política de privacidade",
                icon: "lock.fill",
                action: coordinator.pushToPrivacy
            )
        }
        .scrollDisabled(true)
        .frame(height: 200)
        .scrollContentBackground(.hidden)
        .background(Color(.appBg))
        .padding(.horizontal, 16)
    }
}

#Preview {
    ProfileView()
        .environment(ProfileCoordinator())
}

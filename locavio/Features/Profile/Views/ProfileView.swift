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
    
    
    // futuras queries
//    @Query private var userProfiles: [UserProfile]
//    @Query private var properties: [Property]
//    @Query private var tenants: [Tenant]
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color(UIColor.appBg)
                    .ignoresSafeArea()
                
                VStack(spacing: 13){
                    profileHeader
                    notificationSettings
                }

                
            }
            .navigationTitle("Perfil")
            .navigationBarTitleDisplayMode(.large)
            .toolbar{
                ProfileToolbar(onClick: {})
            }
        }
        
    }
    
    @ViewBuilder
    var profileHeader: some View {
        VStack {
            ProfileHeader(
                userImage: nil,
                userName: "Julis",
                maskedDocument: "***********",
                numberOfProperties: 10,
                numberOfTenants: 5
            )
        }
        .padding(.horizontal, 90)
    }
    
    @ViewBuilder
    var notificationSettings: some View {
        Form{
            OptionToggle(text: "Notificar Pagamentos", isOn: $viewModel.notifyPayments)
            
            OptionToggle(text: "Notificar Vencimentos", isOn: $viewModel.notifyPendentPayments)
            
            OptionToggle(text: "Notificar Chamados", isOn: $viewModel.notifyTickets)
        }
        .scrollContentBackground(.hidden)
        .background(Color(.appBg))
        .padding(.horizontal, 16)
    }
}

#Preview {
    ProfileView()
}

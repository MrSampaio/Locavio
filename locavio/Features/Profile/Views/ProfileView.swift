//
//  ProfileView.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftUI
import SwiftData

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    @Environment(ProfileCoordinator.self) private var coordinator
    
    @Environment(AppleAuthManager.self) private var authManager
    
    @Query private var users: [Owner]
    
    private var user: Owner? {
        users.first
    }
    
    
    // futuras queries
    //    @Query private var userProfiles: [UserProfile]
    //    @Query private var properties: [Property]
    //    @Query private var tenants: [Tenant]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                profileHeader
                notificationSettings
                legalSection
                buttonsSection
            }
            
            .alert("Sair da conta", isPresented: $viewModel.showLogoutAlert){
                
                Button("Cancelar", role: .cancel) {
                }
                
                Button("Sair", role: .destructive) {
                    authManager.logout()
                }
            } message: {
                Text("Tem certeza de que deseja sair do aplicativo?")
            }
    
            .padding(.bottom, 30)
        }
        .background(Color(UIColor.appBg))
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .bottom)
        .navigationTitle("Perfil")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ProfileToolbar(onClick: {
                coordinator.presentEditProfile(user: user!)
            })
        }
    }
    
    @ViewBuilder
    var profileHeader: some View {
        
        // extrai o documento
        let rawDoc = user?.documentNumber ?? ""
        
        let maskedString = rawDoc.isEmpty ? "***.***.***-**" : viewModel.maskDocument(rawDoc)
        
        #warning("Adicionar lógica de numeros de inquilinos")
        
        VStack(alignment: .center){
            ProfileHeader(
                userImage: user?.profilePicture,
                userName: "\(user?.fullName ?? "Proprietário")",
                maskedDocument: "\(maskedString)",
                numberOfProperties: viewModel
                    .calculateTotalProperties(from: user?.properties),
                numberOfTenants: viewModel.calculateActiveTenants(from: user?.properties)
            )
        }
    }
    
    @ViewBuilder
    var notificationSettings: some View {
        VStack(spacing: 0) {
            OptionToggle(text: "Notificar Pagamentos", isOn: $viewModel.notifyPayments)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            
            Divider()
                .padding(.leading, 16)
            
            OptionToggle(text: "Notificar Vencimentos", isOn: $viewModel.notifyPendentPayments)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            
            Divider()
                .padding(.leading, 16)
            
            OptionToggle(text: "Notificar Chamados", isOn: $viewModel.notifyTickets)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
        }
        .background(Color(.bgBox))
        .cornerRadius(24)
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    var legalSection: some View {
        VStack(spacing: 0) {
            LegalOption(
                text: "Termos de uso",
                icon: "text.page.fill",
                action: coordinator.pushToTerms
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            
            Divider()
                .padding(.leading, 16)
            
            LegalOption(
                text: "Política de privacidade",
                icon: "lock.fill",
                action: coordinator.pushToPrivacy
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .background(Color(.bgBox))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    var buttonsSection: some View {
        VStack(spacing: 16) {
            ComponentButton(
                textButton: "Sair",
                action: {
                    viewModel.showLogoutAlert.toggle()
                },
                variant: .secondary
            )
            
            DestructiveButton(text: "Excluir Conta", action: {})
        }
        
        .padding(.horizontal, 16)
    }
}

#Preview {
    ProfileView()
        .environment(ProfileCoordinator())
}



//Button(action: {
//    coordinator.path.append(.newProperty)
//}) {
//    Text("Adicionar Novo Imóvel")
//}
//
//// Exemplo passando um parâmetro para a rota de detalhes
//Button(action: {
//    let idDoImovel = 1 // Isso viria do seu SwiftData
//    coordinator.path.append(.details(id: idDoImovel))
//}) {
//    Text("Ver Detalhes do Imóvel 1")
//}

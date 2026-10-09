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
    @Environment(\.modelContext) private var context
    @Query private var users: [Owner]
    
    // só o Owner da conta que está logada (e não "o primeiro que aparecer" no banco)
    private var user: Owner? {
        guard let userID = authManager.currentUserID else { return nil }
        return users.first { $0.appleUserID == userID }
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
            
            .alert("Excluir Conta Permanentemente", isPresented: $viewModel.showDeleteAccountAlert) {
                
                Button("Cancelar", role: .cancel) { }
                
                Button("Excluir Tudo", role: .destructive) {
                    if let currentUser = user {
                        viewModel.deleteAccount(
                            user: currentUser,
                            context: context,
                            authManager: authManager
                        )
                    }
                }
            } message: {
                Text("Esta ação é irreversível. Todos os seus imóveis, inquilinos, contratos, despesas e pagamentos serão apagados permanentemente.\n\nPara desvincular também o Locavio do seu ID Apple, acesse Ajustes › seu nome › Iniciar Sessão com a Apple › Locavio › Parar de Usar.")
            }
            
            .alert("Não foi possível excluir", isPresented: $viewModel.showDeleteErrorAlert) {
                Button("Entendi", role: .cancel) { }
            } message: {
                Text("Ocorreu um erro ao excluir sua conta. Seus dados não foram apagados. Tente novamente.")
            }
            
            .padding(.bottom, 30)
        }
        .background(Color(UIColor.appBg))
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .bottom)
        .navigationTitle("Perfil")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            EditToolbar(onClick: {
                if let currentUser = user {
                    coordinator.presentEditProfile(user: currentUser)
                }
            })
        }
    }
    
    @ViewBuilder
    var profileHeader: some View {
        
        // extrai o documento
        let rawDoc = user?.documentNumber ?? ""
        
        let maskedString = rawDoc.isEmpty ? "***.***.***-**" : viewModel.maskDocument(rawDoc)
        
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
            
            DestructiveButton(text: "Excluir Conta", action: {
                viewModel.showDeleteAccountAlert = true
            })
        }
        
        .padding(.horizontal, 16)
    }
}

#Preview {
    ProfileView()
        .environment(ProfileCoordinator())
        .environment(AppleAuthManager())
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

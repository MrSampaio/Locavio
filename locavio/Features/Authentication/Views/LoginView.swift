//
//  LoginView.swift
//  locavio
//
//  Created by Julio Sampaio on 19/09/26.
//

import SwiftUI
import SwiftData
import AuthenticationServices

struct LoginView: View {
    @Environment(AppleAuthManager.self) var appleAuthManager
    
    // contexto do swift data
    @Environment(\.modelContext) private var context
    
    // instância da viewmodel de login
    @State private var loginViewModel = LoginViewModel()
    
    let gradientStops: [Gradient.Stop] = [
        Gradient.Stop(color: .loginGradient3, location: 0.0),
        Gradient.Stop(color: .loginGradient2, location: 0.3),
        Gradient.Stop(color: .loginGradient1, location: 1.0)
    ]
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(stops: gradientStops),
                        startPoint: .top,
                        endPoint: .bottom)
                )
                .ignoresSafeArea()
            
            
            VStack {
                
                Spacer()
                
                Image("LocavioLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 280)
                
                Spacer()
                Spacer()
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("Boas-Vindas!")
                        .font(.title.bold())
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 14)
                    
                    Image("termsIcon")
                    
                    
                    Text("O Locavio é um app para fazer a gestão de seus imóveis. Para uma melhor experiência, coletamos a numeração do seu documento, seu nome e email, os quais serão utilizados exclusivamente para a validação da sua identidade e não serão compartilhados com outros usuários.")
                        .font(.caption)
                        .foregroundStyle(.primary)
                    
                    Text("Veja como seus dados são gerenciados...")
                        .font(.caption.bold())
                        .foregroundStyle(.darkerPalette)
                    
                    SignInWithAppleButton(.continue) {
                        request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        switch result {
                            case .success(let authorization):
                                
                                // extrai o ID (e nome/email, se a Apple enviar) da credencial
                                guard let info = appleAuthManager.handleAuthorization(authorization) else { return }
                                
                                // cria/atualiza o Owner no SwiftData para subir pro iCloud e decide a próxima tela
                                // passa o contexto como parâmetro pq o swift data só pode ser usado em structs
                                loginViewModel.syncUserToSwiftData(info: info, context: context, authManager: appleAuthManager)
                                
                            case .failure(let error):
                                print("Error when trying to sign in: \(error.localizedDescription)")
                        }
                    }
                    //            .signInWithAppleButtonStyle(.whiteOutline)
                    .frame(height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 100))
                }
                .padding(30)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 38))
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 38))
            }
            .padding()
        }
        //        .task{
        //            appleAuthManager.checkCredentialStatus()
        //        }
        
    }
}


#Preview {
    LoginView()
        .environment(AppleAuthManager())
}

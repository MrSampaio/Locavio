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

    var body: some View {
        VStack{
            
            Text("Essa vai ser a tela de login, fé que agora vai")
                .bold()
            
            SignInWithAppleButton(.continue){
                request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                switch result {
                case .success(let authorization):
                    
                    // atualiza a variável isAuthenticated do App
                    appleAuthManager.handleAuthorization(authorization)
                                        
                    // sincroniza com o SwiftData para subir pro iCloud
                    // passa o contexto como parâmetro pq o swift data só pode ser usado em structs
                    loginViewModel.syncUserToSwiftData(context: context)
                    
                case .failure(let error):
                    print("Error when trying to sign in: \(error.localizedDescription)")
                }
            }
            .signInWithAppleButtonStyle(.white)
            .padding(.horizontal, 26)
            .frame(height: 50)
        }
        
        .padding()
//        .task{
//            appleAuthManager.checkCredentialStatus()
//        }
        
    }
}


#Preview {
    LoginView()
        .environment(AppleAuthManager())
}

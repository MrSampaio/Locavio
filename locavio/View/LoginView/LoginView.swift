//
//  LoginView.swift
//  locavio
//
//  Created by Julio Sampaio on 19/09/26.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @State private var appleAuthManager = AppleAuthManager()

    var body: some View {
        VStack{
            SignInWithAppleButton(.continue){
                request in
                
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                switch result {
                case .success(let authorization):
                    appleAuthManager.handleAuthorization(authorization)
                    print("User logged successfully!")
                    
                case .failure(let error):
                    print("Error when trying to sign in: \(error.localizedDescription)")
                }
                

            }
            .signInWithAppleButtonStyle(.black)
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
}

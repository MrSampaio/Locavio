//
//  AppleAuthManager.swift
//  locavio
//
//  Created by Julio Sampaio on 19/09/26.
//

import SwiftUI
import AuthenticationServices

@Observable
class AppleAuthManager{
    func handleAuthorization(_ authorization: ASAuthorization){
        
        // guard let para converter a credencial para o tipo AppleIDCredential
        // essa credential vai ser a chave de identificação do usuário no sistema
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential
        else{
            print("User invalid credentials")
            return
        }
        
        // o userID vai ser a chave de identificação do usuário no sistema
        let userID = credential.user
        
        // guard let para receber o tokenData. será utilizado nas validações
        // esse é o JWT que pode ser usado para validar a identidade do usuário
        guard let tokenData = credential.identityToken, let token = String(data: tokenData, encoding: .utf8) else {
            print("Error when trying to access tokenData")
            return
            
        }
        
        // guard let que recebe o código de autorização. vai ser usado como código único das validações
        guard let codeData = credential.authorizationCode, let code = String(data: codeData, encoding: .utf8) else{
            print("Error when trying to access codeData")
            return
        }
        
        
        
        
        
    }
}

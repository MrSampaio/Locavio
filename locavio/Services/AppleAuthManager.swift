//
//  AppleAuthManager.swift
//  locavio
//
//  Created by Julio Sampaio on 19/09/26.
//

import SwiftUI
import AuthenticationServices
import Security

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
        // esse é o JWT que pod ser usado para validar a identidade do usuário
        guard let tokenData = credential.identityToken, let token = String(data: tokenData, encoding: .utf8) else {
            print("Error when trying to access tokenData")
            return
            
        }
        
        // guard let que recebe o código de autorização. vai ser usado como código único das validações
        guard let codeData = credential.authorizationCode, let code = String(data: codeData, encoding: .utf8) else{
            print("Error when trying to access codeData")
            return
        }
        
//        =========================================================================
        
        // IMPORTANTE DE NÃO ESQUECER: o apple login só retorna nome e email uma vez.
        // caso esses dados não sejam salvos de primeira, o usuário precisa reinstalar o app para conseguir logar devidamente
        
        // ou seja, NÃO ESQUECE DE SALVAR AS COISAS
        
//        ===========================================================
        
        
        // tenta pegar o nome completo do usuário
        
        if let fullName = credential.fullName {
            let givenName = fullName.givenName ?? ""
            let familyName = fullName.familyName ?? ""
            // depois faz a lógica aqui pra salvar o nome do usuário
        }
        
        // tenta pegar o email do usuário
        if let userEmail = credential.email {
            // depois faz a lógica aqui pra salvar o email do usuário
        }
        
        // REMOVE ISSO DEPOIS QUE CRIAR O KEYCHAINHELPER!!!!!!!!!!!!!!!!!!!!!!!!!!
        UserDefaults.standard.set(userID, forKey: "appleUserID")
        
        // salva a identificação do usuário no Keychain do dispositivo
        // melhor salvar lá do que no userdefaults por questão de segurança
        //KeychainHelper.shared.saveUserIdentifier(userID)
        
    }
}

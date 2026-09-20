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
    
    let keychainHelper = KeychainHelper.shared
    
    func handleAuthorization(_ authorization: ASAuthorization){
        
        // puxa o KeychainHelper pra simplificar a escrita
        
        
        // guard let para converter a credencial para o tipo AppleIDCredential
        // essa credential vai ser a chave de identificação do usuário no sistema
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential
        else{
            print("User invalid credentials")
            return
        }
        
        // o userID vai ser a chave de identificação do usuário no sistema
        let userID = credential.user
        
        // salva o userID no keychain pra maior segurançå
        keychainHelper.save(userID, for: "appleUserID")
        
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
            
            // limpa o nome recebido
            let completeName = "\(givenName) \(familyName)".trimmingCharacters(in: .whitespaces)
                
            // salva o nome no Keychain para maior segurança
            if !completeName.isEmpty {
                keychainHelper.save(completeName, for: "appleUserFullName")
            }
            // depois faz a lógica aqui pra salvar o nome do usuário
        }
        
        // tenta pegar o email do usuário
        if let userEmail = credential.email {
            keychainHelper.save(userEmail, for: "appleUserEmail")
        }
    }
    
    func checkCredentialStatus(){
        
        // pega o ID do usuário salvo no Userdefaults
        guard let userID = keychainHelper.readString(for: "appleUserID") else {
            print("There is no user logged in Keychain storage.")
            return
        }
        
        let provider = ASAuthorizationAppleIDProvider()
        
        provider.getCredentialState(forUserID: userID){
            status, error in
            
            DispatchQueue.main.async{
                switch status{
                case.authorized:
                    print("User is authorized!")
                    //HomeView()
                    
                // importante: as infos precisam ser apagadas do Keychain caso o usuário tenha revogado o acesso do app aos seus dados
                case.revoked:
                    print("User revoked access")
                    self.keychainHelper.delete(for: "appleUserID")
                    self.keychainHelper.delete(for: "appleUserFullName")
                    self.keychainHelper.delete(for: "appleUserEmail")
                    
                case.notFound:
                    print("User never logged with Apple Sign In in this device.")
                    
                case.transferred:
                    print("Credential transfered.")
                    
                @unknown default:
                    break
                }
                
                
                
            }
        }
    }
}

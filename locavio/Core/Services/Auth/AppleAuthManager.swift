//
//  AppleAuthManager.swift
//  locavio
//
//  Created by Julio Sampaio on 19/09/26.
//

import SwiftUI
import AuthenticationServices
import Security
import SwiftData

enum AppAuthState{
    case needsRegistration
    case authenticated
    case loggedOut
}

@Observable
final class AppleAuthManager{
    
    
//    var firtUse: Bool = false
    
    var currentAuthState: AppAuthState = .loggedOut
    
    // variável que controla autenticação do usuário
    var isAuthenticated: Bool = false
    
    // puxa o KeychainHelper pra simplificar a escrita
    let keychainHelper = KeychainHelper.shared
    
    init() {
        checkIfIsFirstLaunchAfterInstall()
    }
    
    // funçao para verificar se é o primeiro uso e se foi desinstalado
    private func checkIfIsFirstLaunchAfterInstall() {
        // verifica se a chave "hasLaunchedBefore" existe no UserDefaults
        let hasLaunched = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        
        if !hasLaunched {
            // se for false é pq o app acabou de ser instalado/reinstalado.
           
            // logout pra forçar o login
            logout()
            
            // marca como true para a próxima validação
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }
    }
    
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
        
        // salva o userID no keychain pra maior segurançå
        keychainHelper.save(userID, for: "appleUserID")
        
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
        
        currentAuthState = .needsRegistration
        
        // caso tudo tenha dado certo, seta o controle de autenticação para true
//        DispatchQueue.main.async {
//            self.currentAuthState = .needsRegistration
//        }
    }
    
    func checkCredentialStatus(context: ModelContext){
        
        // pega o ID do usuário salvo no Userdefaults
        guard let userID = keychainHelper.readString(for: "appleUserID") else {
            print("There is no user logged in Keychain storage.")
            DispatchQueue.main.async { self.isAuthenticated = false }
            return
        }
        
        let provider = ASAuthorizationAppleIDProvider()
        
        provider.getCredentialState(forUserID: userID){
            status, error in
            
            DispatchQueue.main.async{
                switch status{
                case.authorized:
                    print("User is authorized!")
                    self.isAuthenticated = true
                        
                        let descriptor = FetchDescriptor<Owner>(predicate: #Predicate { $0.appleUserID == userID })
                        if let user = try? context.fetch(descriptor).first, let doc = user.documentNumber, !doc.isEmpty {
                            self.currentAuthState = .authenticated
                        } else {
                            self.currentAuthState = .needsRegistration
                        }
                        
//                        #warning("")
                    
                // importante: as infos precisam ser apagadas do Keychain caso o usuário tenha revogado o acesso do app aos seus dados
                case.revoked, .notFound, .transferred:
                print("User revoked access, not found or revoked")
                self.logout()

                @unknown default:
                    break
                }
            }
        }
    }
    
    func logout(){
        keychainHelper.delete(for: "appleUserID")
        keychainHelper.delete(for: "appleUserFullName")
        keychainHelper.delete(for: "appleUserEmail")
        
        currentAuthState = .loggedOut
    }
}

//
//  AppleAuthManager.swift
//  locavio
//
//  Created by Julio Sampaio on 19/09/26.
//

import SwiftUI
import AuthenticationServices
import SwiftData

enum AppAuthState {
    case needsRegistration
    case authenticated
    case loggedOut
}

// dados que a Apple entrega no login.
struct AppleSignInInfo {
    let userID: String
    let fullName: String?
    let email: String?
}

@Observable
final class AppleAuthManager {
    
    var currentAuthState: AppAuthState = .loggedOut
    
    // puxa o KeychainHelper pra simplificar a escrita
    private let keychainHelper = KeychainHelper.shared
    
    // ID do usuário logado. é a única informação que fica no Keychain
    var currentUserID: String? {
        keychainHelper.readString(for: KeychainKey.appleUserID)
    }
    
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
    
    // extrai o que a Apple enviou e guarda SÓ o ID no Keychain.
    // quem decide pra qual tela ir é o LoginViewModel, depois de olhar o SwiftData
    func handleAuthorization(_ authorization: ASAuthorization) -> AppleSignInInfo? {
        
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("User invalid credentials")
            return nil
        }
        
        // o userID é a chave de identificação do usuário no sistema
        keychainHelper.save(credential.user, for: KeychainKey.appleUserID)
        
        // nome completo: só vem na primeira autorização. nas outras vezes fullName é nil
        var fullName: String?
        if let components = credential.fullName {
            let name = [components.givenName, components.familyName]
                .compactMap { $0 }
                .joined(separator: " ")
                .trimmingCharacters(in: .whitespaces)
            
            fullName = name.isEmpty ? nil : name
        }
        
        return AppleSignInInfo(
            userID: credential.user,
            fullName: fullName,
            email: credential.email
        )
    }
    
    func checkCredentialStatus(context: ModelContext) {
        
        // pega o ID do usuário salvo no Keychain
        guard let userID = currentUserID else {
            print("There is no user logged in Keychain storage.")
            currentAuthState = .loggedOut
            return
        }
        
        let provider = ASAuthorizationAppleIDProvider()
        
        provider.getCredentialState(forUserID: userID) { status, error in
            
            DispatchQueue.main.async {
                switch status {
                    case .authorized:
                        print("User is authorized!")
                        self.routeAuthorizedUser(userID: userID, context: context)
                        
                    case .revoked:
                        print("User revoked access.")
                        self.handleCredentialRevoked(context: context)
                        
                    case .notFound, .transferred:
                        print("User not found or transferred.")
                        self.logout()
                        
                    @unknown default:
                        break
                }
            }
        }
    }
    
    // decide a tela de um usuário que a Apple confirmou como autorizado
    private func routeAuthorizedUser(userID: String, context: ModelContext) {
        let descriptor = FetchDescriptor<Owner>(predicate: #Predicate { $0.appleUserID == userID })
        
        if let owner = try? context.fetch(descriptor).first,
           let doc = owner.documentNumber, !doc.isEmpty {
            currentAuthState = .authenticated
        } else {
            currentAuthState = .needsRegistration
        }
    }
    
    // chamado quando a Apple avisa que o acesso foi revogado
    // (credentialRevokedNotification ou .revoked no getCredentialState).
    // a TN3194 da Apple manda apagar todos os dados do usuário, inclusive Keychain e disco, e voltar ao login
    func handleCredentialRevoked(context: ModelContext) {
        guard let userID = currentUserID else {
            logout()
            return
        }
        
        do {
            try deleteLocalAccount(userID: userID, context: context)
        } catch {
            print("Error when trying to erase local data after revocation: \(error.localizedDescription)")
            
            // mesmo se der erro, encerra a sessão
            logout()
        }
    }

    func deleteLocalAccount(userID: String, context: ModelContext) throws {
        let descriptor = FetchDescriptor<Owner>(predicate: #Predicate { $0.appleUserID == userID })
        
        for owner in try context.fetch(descriptor) {
            context.delete(owner)
        }
        
        do {
            // salva na hora pra garantir que os dados sumam do banco local (e do CloudKit, se estiver ligado)
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
        
        logout()
    }
    
    // encerra só a SESSÃO neste aparelho. NÃO apaga nenhum dado do usuário no SwiftData,
    // então ao entrar de novo o perfil, o nome e os imóveis continuam lá
    func logout() {
        keychainHelper.delete(for: KeychainKey.appleUserID)
        
        // limpa chaves de versões antigas do app, que guardavam nome e email no Keychain
        keychainHelper.delete(for: KeychainKey.legacyFullName)
        keychainHelper.delete(for: KeychainKey.legacyEmail)
        
        currentAuthState = .loggedOut
    }
}

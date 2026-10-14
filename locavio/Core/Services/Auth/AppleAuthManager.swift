//
//  AppleAuthManager.swift
//  locavio
//
//  Created by Julio Sampaio on 19/09/26.
//

import SwiftUI
import AuthenticationServices
import SwiftData
import CoreData
import os

enum AppAuthState {
    case loading
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
    
    var currentAuthState: AppAuthState = .loading
    
    // puxa o KeychainHelper pra simplificar a escrita
    private let keychainHelper = KeychainHelper.shared
    
    // contexto principal, guardado em checkCredentialStatus pra poder juntar Owners duplicados
    // quando o iCloud entregar dados novos
    @ObservationIgnored private var context: ModelContext?
    
    // vira true quando o iCloud termina a primeira importação (com ou sem erro)
    @ObservationIgnored private var cloudImportFinished = false
    @ObservationIgnored private var cloudObserver: NSObjectProtocol?
    @ObservationIgnored private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "locavio", category: "CloudSync")
    
    // ID do usuário logado. é a única informação que fica no Keychain
    var currentUserID: String? {
        keychainHelper.readString(for: KeychainKey.appleUserID)
    }
    
    init() {
        checkIfIsFirstLaunchAfterInstall()
        observeCloudSync()
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
    
    // MARK: - iCloud
    
    // o SwiftData avisa por essa notificação quando o CloudKit termina de importar/exportar.
    // serve pra saber se já dá pra concluir que a conta NÃO existe no iCloud, e pra logar erros de sincronização
    private func observeCloudSync() {
        cloudObserver = NotificationCenter.default.addObserver(
            forName: NSPersistentCloudKitContainer.eventChangedNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let event = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey]
                    as? NSPersistentCloudKitContainer.Event,
                  event.endDate != nil else { return }
            
            let kind: String
            switch event.type {
                case .setup: kind = "setup"
                case .import: kind = "import"
                case .export: kind = "export"
                @unknown default: kind = "unknown"
            }
            let succeeded = event.succeeded
            let errorText = event.error?.localizedDescription
            
            Task { @MainActor in
                self?.handleCloudEvent(kind: kind, succeeded: succeeded, errorText: errorText)
            }
        }
    }
    
    @MainActor
    private func handleCloudEvent(kind: String, succeeded: Bool, errorText: String?) {
        if let errorText {
            logger.error("CloudKit \(kind, privacy: .public) failed: \(errorText, privacy: .public)")
        }
        
        guard kind == "import" else { return }
        cloudImportFinished = true
        
        if succeeded { refreshAfterImport() }
    }
    
    // o iCloud entregou dados novos: junta Owners duplicados e, se o cadastro estava pendente
    // mas a conta antiga chegou, entra direto no app
    @MainActor
    private func refreshAfterImport() {
        guard let context, let userID = currentUserID,
              let owner = resolveOwner(userID: userID, context: context) else { return }
        
        if currentAuthState == .needsRegistration,
           let doc = owner.documentNumber, !doc.isEmpty {
            currentAuthState = .authenticated
        }
    }
    
    // MARK: - Owner
    
    // busca o Owner do usuário. se existir mais de um com o mesmo appleUserID, JUNTA todos num só.
    // (o SwiftData com CloudKit não tem @Attribute(.unique), então depois de reinstalar pode haver
    // um Owner criado localmente e outro que veio do iCloud)
    func resolveOwner(userID: String, context: ModelContext) -> Owner? {
        let descriptor = FetchDescriptor<Owner>(predicate: #Predicate { $0.appleUserID == userID })
        
        guard let owners = try? context.fetch(descriptor), !owners.isEmpty else { return nil }
        guard owners.count > 1 else { return owners[0] }
        
        return mergeDuplicatedOwners(owners, context: context)
    }
    
    // atalho pras telas: o Owner do usuário logado agora (use no lugar de "owners.first")
    func currentOwner(context: ModelContext) -> Owner? {
        guard let userID = currentUserID else { return nil }
        return resolveOwner(userID: userID, context: context)
    }
    
    private func mergeDuplicatedOwners(_ owners: [Owner], context: ModelContext) -> Owner {
        
        // o principal é o que já tem documento. no empate, o que tem mais imóveis
        let sorted = owners.sorted { a, b in
            let aRegistered = !(a.documentNumber ?? "").isEmpty
            let bRegistered = !(b.documentNumber ?? "").isEmpty
            
            if aRegistered != bRegistered { return aRegistered }
            return (a.properties?.count ?? 0) > (b.properties?.count ?? 0)
        }
        
        let primary = sorted[0]
        let duplicates = Array(sorted.dropFirst())
        
        for duplicate in duplicates {
            
            // completa o principal com o que estiver faltando nele
            primary.fullName = firstFilled(primary.fullName, duplicate.fullName)
            primary.email = firstFilled(primary.email, duplicate.email)
            primary.phone = firstFilled(primary.phone, duplicate.phone)
            primary.documentNumber = firstFilled(primary.documentNumber, duplicate.documentNumber)
            primary.documentType = primary.documentType ?? duplicate.documentType
            primary.profilePicture = primary.profilePicture ?? duplicate.profilePicture
            primary.notifyPayments = primary.notifyPayments ?? duplicate.notifyPayments
            primary.notifyDueDate = primary.notifyDueDate ?? duplicate.notifyDueDate
            primary.notifyTickets = primary.notifyTickets ?? duplicate.notifyTickets
            
            // passa os imóveis pro principal ANTES de apagar o duplicado.
            // como o Owner tem deleteRule .cascade, apagar um Owner que ainda tem imóveis
            // apaga também os imóveis, chamados, pagamentos, contratos... (e isso sobe pro iCloud)
            for property in Array(duplicate.properties ?? []) {
                property.owner = primary
            }
        }
        
        // grava a transferência primeiro. só depois apaga os duplicados
        do {
            try context.save()
        } catch {
            context.rollback()
            logger.error("Could not move properties to main owner: \(error.localizedDescription, privacy: .public)")
            return primary
        }
        
        for duplicate in duplicates {
            // trava de segurança: só apaga se não sobrou nenhum imóvel nele
            if (duplicate.properties ?? []).isEmpty {
                context.delete(duplicate)
            }
        }
        
        try? context.save()
        
        return primary
    }
    
    private func firstFilled(_ a: String?, _ b: String?) -> String? {
        if let a, !a.isEmpty { return a }
        return b
    }
    
    // espera o Owner chegar do iCloud antes de desistir:
    // - já existe no banco local: devolve na hora
    // - o iCloud ainda está baixando: espera (no máximo ~12s)
    // - o iCloud já terminou de importar e o Owner não veio: espera só mais 3s de margem e desiste
    // - aparelho sem conta do iCloud: não espera nada
    @MainActor
    func waitForOwner(userID: String, context: ModelContext) async -> Owner? {
        if let owner = resolveOwner(userID: userID, context: context) { return owner }
        
        let deadline = ContinuousClock.now + .seconds(12)
        var graceDeadline: ContinuousClock.Instant?
        
        while ContinuousClock.now < deadline {
            
            if FileManager.default.ubiquityIdentityToken == nil { break }
            
            if cloudImportFinished {
                let limit = graceDeadline ?? (ContinuousClock.now + .seconds(3))
                graceDeadline = limit
                if ContinuousClock.now >= limit { break }
            }
            
            try? await Task.sleep(for: .milliseconds(500))
            
            if let owner = resolveOwner(userID: userID, context: context) { return owner }
        }
        
        return resolveOwner(userID: userID, context: context)
    }
    
    // MARK: - Login
    
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
        
        self.context = context
        
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
                        Task { @MainActor in
                            await self.routeAuthorizedUser(userID: userID, context: context)
                        }
                        
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
    @MainActor
    private func routeAuthorizedUser(userID: String, context: ModelContext) async {
        let owner = await waitForOwner(userID: userID, context: context)
        
        if let doc = owner?.documentNumber, !doc.isEmpty {
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

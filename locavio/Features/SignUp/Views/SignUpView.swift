//
//  SignUpView.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//
import Foundation
import SwiftUI
import SwiftData

struct SignUpView: View {
    
    @State private var signUpViewModel = SignUpViewModel()
    
    @Environment(\.modelContext) private var context
    @Environment(AppleAuthManager.self) private var authManager
    
    var body: some View {
        ZStack {
            Color(UIColor.appBg)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 24) {
                titleSection
                documentSection
            }
            .background(Color(.appBg))
        }
        .alert("Erro no Cadastro", isPresented: $signUpViewModel.showAlert) {
            Button("Entendi", role: .cancel) { }
        } message: {
            Text(signUpViewModel.alertMessage)
        }
        .task {
            // descobre se precisa pedir o nome (a Apple só envia na primeira autorização)
            signUpViewModel.loadOwner(context: context, authManager: authManager)
        }
    }
    
    @ViewBuilder
    private var titleSection: some View {
        HStack {
            SignUpTitle(title: "Informações Pessoais", subtitle: "Precisamos de algumas informações para configurar seu perfil. Você poderá revisar essas informações depois nas configurações da conta.")
        }
        .padding(.horizontal, 40)
    }
    
    @ViewBuilder
    private var nameRow: some View {
        HStack(spacing: 16) {
            Image(systemName: "person.fill")
                .font(.title3)
                .foregroundColor(.accentColor)
            
            Text("Nome")
                .font(.body)
            
            Spacer()
            
            TextField("Seu nome completo", text: $signUpViewModel.fullName)
                .multilineTextAlignment(.trailing)
                .textContentType(.name)
                .textInputAutocapitalization(.words)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var documentSection: some View {
        VStack(alignment: .center, spacing: 12) {
            VStack(spacing: 16) {
                
                if signUpViewModel.needsFullName {
                    nameRow
                    
                    Divider()
                        .padding(.horizontal, 50)
                }
                
                DocumentTypePicker(selection: $signUpViewModel.selectedDocumentType)
                
                Divider()
                    .padding(.horizontal, 50)
                
                DocumentTextField(text: $signUpViewModel.documentNumber, documentType: signUpViewModel.selectedDocumentType)
            }
            .padding(16)
            .background(Color(.bgForm))
            .cornerRadius(34)
            .padding(.horizontal, 24)
            .onChange(of: signUpViewModel.documentNumber) {
                oldValue,
                newValue in
                let maskedText = signUpViewModel.maskDocument(
                    text: newValue,
                    type: signUpViewModel.selectedDocumentType
                )
                
                if signUpViewModel.documentNumber != maskedText {
                    signUpViewModel.documentNumber = maskedText
                }
            }
            .onChange(of: signUpViewModel.selectedDocumentType) { oldValue, newValue in
                signUpViewModel.documentNumber = ""
            }
            
            VStack(alignment: .center) {
                TipsText(text: "Utilizamos seu documento exclusivamente para sua identificação e ele não será compartilhado com outros usuários.")
                
                ComponentButton(
                    textButton: "Começar",
                    action: {
                        signUpViewModel.saveDocument(
                            document: signUpViewModel.documentNumber,
                            documentType: signUpViewModel.selectedDocumentType,
                            context: context,
                            authManager: authManager
                        )
                    }
                )
                .padding(.horizontal, 65)
                .disabled(!signUpViewModel.isValid)
                
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 24)
        .background(.bgBox, in: RoundedRectangle(cornerRadius: 38))
        .padding(.horizontal, 16)
    }
}

#Preview {
    SignUpView()
        .environment(AppleAuthManager())
}

//
//  EditProfileSheet.swift
//  locavio
//
//  Created by Julio Sampaio on 04/10/26.
//

import Foundation
import SwiftUI
import SwiftData

struct EditProfileSheet: View {
    
    @Environment(\.modelContext) private var context
    @Environment(ProfileCoordinator.self) private var coordinator

    @State var viewModel = EditProfileViewModel()
    @State var user: Owner

    var body: some View {
        NavigationStack{
            VStack(alignment: .center, spacing: 26){
                
                ProfilePhotoPicker(
                    imageData: $viewModel.userImageData
                )
                
                TipsText(text: "Toque para alterar sua foto de perfil")
                
                documentSection
                
                Spacer()
                
            }
            .onChange(of: viewModel.documentNumber) {
                oldValue,
                newValue in
                let maskedText = viewModel.maskDocument(
                    text: newValue,
                    type: viewModel.selectedDocumentType
                )
                
                if viewModel.documentNumber != maskedText {
                    viewModel.documentNumber = maskedText
                }
            }
            .onAppear {
                viewModel.loadUserData(user: user)
            }
            
            .onChange(of: viewModel.selectedDocumentType) { _, newValue in
                viewModel.documentTypeDidChange(to: newValue)
            }
            .toolbar {
                SheetsToolbar(
                    onConfirm: {
                        
                        let success = viewModel.saveUserData(context: context, user: user)
                        
                        if success {
                            coordinator.dismissSheet()
                        }
                        
                        
                    },
                    onClose: {
                        coordinator.dismissSheet()
                    },
                    title: "Editar Perfil"
                )
            }
            
            .alert("Erro ao Salvar", isPresented: $viewModel.showErrorAlert) {
                Button("Entendi", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
            .ignoresSafeArea(.keyboard)
            .dismissKeyboardOnTap()

        }
       
    }
    
    @ViewBuilder
    var nameRow: some View {
        HStack(alignment: .top) {
            Image(systemName: "person.fill")
                .foregroundStyle(.accent)

            VStack(alignment: .leading) {
                Text("Nome")
                    .font(.subheadline.bold())

                TextField("Seu nome completo", text: $viewModel.fullName)
                    .textContentType(.name)
                    .textInputAutocapitalization(.words)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    
    @ViewBuilder
    private var documentSection: some View{
        
        VStack(spacing: 16){
            nameRow
            
            Divider()
                .padding(.horizontal, 50)
            
            DocumentTypePicker(selection: $viewModel.selectedDocumentType)
            
            Divider()
                .padding(.horizontal, 50)
            
            DocumentTextField(
                text: $viewModel.documentNumber,
                documentType: viewModel.selectedDocumentType
            )
        }
        
        .padding(16)
        .background(Color(.bgForm))
   
        .cornerRadius(34)
        .padding(.horizontal, 24)
        
        VStack(alignment: .center){
            TipsText(text: "Utilizamos seu documento exclusivamente para sua identificação e ele não será compartilhado com outros usuários.")
            
        }
        .padding(.horizontal, 16)
        

    }
}



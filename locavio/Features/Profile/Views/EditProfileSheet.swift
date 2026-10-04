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
            .onChange(of: viewModel.selectedDocumentType) { oldValue, newValue in
                viewModel.documentNumber = ""
            }
            .onAppear {
                viewModel.loadUserData(user: user)
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
//            .toolbar{
//                SheetsToolbar(
//                    onConfirm: {},
//                    onClose: {},
//                    title: "Editar Perfil"
//                )
//            }
        }
       
    }
    
    @ViewBuilder
    private var documentSection: some View{
        
        VStack(spacing: 16){
            
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
        //            .overlay(
        //                RoundedRectangle(cornerRadius: 34)
        //                    .stroke(signUpViewModel.errorMessage != nil ? .red : .clear, lineWidth: 1.5)
        //            )
        .cornerRadius(34)
        .padding(.horizontal, 24)
        
        VStack(alignment: .center){
            TipsText(text: "Utilizamos seu documento exclusivamente para sua identificação e ele não será compartilhado com outros usuários.")
            
        }
        .padding(.horizontal, 16)
        
//        VStack(alignment: .center, spacing: 12){
//
//        }
////        .padding(.vertical, 24)
////        
////        // se descomentar, vai travar
////        .background(.bgBox, in: RoundedRectangle(cornerRadius: 38))
////        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 38))
////        .padding(.horizontal, 16)
    }
}

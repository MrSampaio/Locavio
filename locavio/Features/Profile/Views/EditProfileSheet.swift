//
//  EditProfileSheet.swift
//  locavio
//
//  Created by Julio Sampaio on 04/10/26.
//

import Foundation
import SwiftUI

struct EditProfileSheet: View {
    
    // passa pra viewmodel depois
    @State private var userImageData: Data? = nil
    
    @State var selectedDocumentType: DocumentTypeModel = .pf
    @State var documentNumber: String = ""
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .center, spacing: 26){
                
                ProfilePhotoPicker(imageData: $userImageData)
                
                TipsText(text: "Toque para alterar sua foto de perfil")
                
                documentSection
                
                Spacer()
                
            }
            .toolbar{
                SheetsToolbar(
                    onConfirm: {},
                    onClose: {},
                    title: "Editar Perfil"
                )
            }
        }
       
    }
    
    @ViewBuilder
    private var documentSection: some View{
        
        VStack(spacing: 16){
            
            DocumentTypePicker(selection: $selectedDocumentType)
            
            Divider()
                .padding(.horizontal, 50)
            
            DocumentTextField(
                text: $documentNumber,
                documentType: selectedDocumentType
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

#Preview {
    EditProfileSheet()
}

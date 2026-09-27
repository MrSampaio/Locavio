//
//  SignUpView.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation
import SwiftUI


struct SignUpView: View {
    
    @State private var signUpViewModel = SignUpViewModel()
    
    var body: some View {
        ZStack{
            Color(UIColor.background)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 24){
                titleSection
                documentSection
            }
            .background(Color(.background))
        }
        
        
    }
    
    @ViewBuilder
    private var titleSection: some View{
        HStack(){
            SignUpTitle(title: "Informações Pessoais", subtitle: "Precisamos de algumas informações para configurar seu perfil. Você poderá revisar essas informações depois nas configurações da conta.")
        }
        .padding(.horizontal, 40)
    }
    
    @ViewBuilder
    private var documentSection: some View{
        VStack(alignment: .center, spacing: 12){
            VStack(spacing: 16){
                DocumentTypePicker(selection: $signUpViewModel.selectedDocumentType)
                
                Divider()
                    .padding(.horizontal, 50)
                
                DocumentTextField(text: $signUpViewModel.documentNumber, documentType: signUpViewModel.selectedDocumentType)
            }
            

            .padding(16)
//            .background(Color(.))
            .background(Color(.secondarySystemBackground))
            .cornerRadius(34)
            .padding(.horizontal, 24)
        }

        .padding(.vertical, 24)
        
        // se descomentar, vai travar
//        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 38))
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 38))
        .padding(.horizontal, 16)
        
        
    }
}

#Preview {
    SignUpView()
}

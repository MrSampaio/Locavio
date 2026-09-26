//
//  HomeView.swift
//  locavio
//
//  Created by Julio Sampaio on 19/09/26.
//

import SwiftUI
import SwiftData

struct PropertiesView: View {
    
    @State private var propertiesViewModel = PropertiesViewModel()
    @Environment(AppleAuthManager.self) var authManager
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        
        VStack{
            
            VStack{
                Text("aopa, \(propertiesViewModel.userName)!")
                Text("Email: \(propertiesViewModel.userEmail)")
            }
            .font(.title)
            .bold()
            
            
            
            Text("Essa é a home view. Só vai aparecer quando o Sign In With Apple funfar")
                .padding()
            
            Button(action: {
                authManager.logout()
            }) {
                Text("Sair do Aplicativo")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .padding(.horizontal, 26)
            .padding(.bottom, 40)
        }
        
        // função para carregar as infos do usuário no momento em que a página é aberta
        .onAppear {
            propertiesViewModel.fetchUserData(context: context)
        }
    }
}

#Preview {
    PropertiesView()
        .environment(AppleAuthManager())
}

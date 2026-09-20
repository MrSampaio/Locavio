//
//  HomeView.swift
//  locavio
//
//  Created by Julio Sampaio on 19/09/26.
//

import SwiftUI

struct HomeView: View {
    
    @State private var homeViewModel = HomeViewModel()
    @Environment(AppleAuthManager.self) var authManager
    
    var body: some View {
        
        VStack{
            
            VStack{
                Text("aopa, \(homeViewModel.userName)!")
                Text("Fé que agora foi T-T")
            }
            .font(.title)
            .bold()
            
            
            Text("O email que veio foi esse aqui: \(homeViewModel.userEmail)")
            
            
            
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
    }
}

#Preview {
    HomeView()
        .environment(AppleAuthManager())
}

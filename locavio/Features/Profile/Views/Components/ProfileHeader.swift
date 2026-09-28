//
//  ProfileHeader.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftUI

struct ProfileHeader: View {
    var body: some View {
        VStack(spacing: 16){
            Image("DefaultUser")
                .cornerRadius(100)
                .frame(width: 150, height: 150)
            
            VStack(spacing: 4){
                Text("Nome de usuário")
                    .font(.title2)
                    .fontWeight(.bold)
                
                // outra bola: ●
                Text("•••.123.•••.456-••")
                
               
            }
            
            HStack(spacing: 12){
                Text("5 imóveis")
                    .font(.default)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(Color(.badget01))
                    .cornerRadius(40)
                
                Text("3 Inquilinos")
                    .font(.default)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(Color(.badget02))
                    .cornerRadius(40)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ProfileHeader()
}

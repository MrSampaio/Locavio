//
//  ProfileHeader.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftUI

struct ProfileHeader: View {
    
    let userImage: Data?
    let userName: String
    let maskedDocument: String
    let numberOfProperties: Int
    let numberOfTenants: Int
    
    var body: some View {
        VStack(spacing: 16){
            
            if let imageData = userImage, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
            } else{
                Image("DefaultUser")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
            }
           
            
            VStack(spacing: 4){
                Text(userName)
                    .font(.title2)
                    .fontWeight(.bold)
                
                // outra bola: ●
                Text(maskedDocument)
            }
            
            HStack(spacing: 12){
                Text("\(String(numberOfProperties)) imóveis")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(Color(.badget01))
                    .cornerRadius(40)
                
                Text("\(String(numberOfTenants)) inquilinos")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
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
    ProfileHeader(
        userImage: nil,
        userName: "Julis Sampaio",
        maskedDocument: "•••.123.•••-••",
        numberOfProperties: 5,
        numberOfTenants: 3
    )
}

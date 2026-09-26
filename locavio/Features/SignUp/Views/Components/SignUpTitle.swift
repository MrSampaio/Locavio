//
//  SignUpTitle.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation
import SwiftUI

struct SignUpTitle: View {
    var title: String
    var subtitle: String
    
    var body: some View {
        
        VStack(spacing: 12){
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.accentColor)
            
            Text(subtitle)
                .font(.callout)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    SignUpTitle(title: "Lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit", subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ")
}

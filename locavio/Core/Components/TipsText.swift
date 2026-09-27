//
//  TipsText.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation
import SwiftUI


struct TipsText: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundColor(.secondary)
            .fontWeight(.regular)
            .multilineTextAlignment(.leading)
    }
}


#Preview {
    TipsText(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation")
}

    
       

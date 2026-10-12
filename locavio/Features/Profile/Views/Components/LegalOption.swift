//
//  LegalOption.swift
//  locavio
//
//  Created by Julio Sampaio on 01/10/26.
//

import Foundation
import SwiftUI

struct LegalOption: View {
    
    var text: String
    var icon: String
    let action: () -> Void
    
    var body: some View {
        
        
        Button(action: action) {
            HStack{
                Image(systemName: icon)
                    .foregroundColor(Color.accentColor)
                    .font(.system(size: 28))
                
                Text(text)
                    .font(.body)
                    .fontWeight(.regular)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.body)
                    .foregroundColor(Color.secondary)
                    .fontWeight(.semibold)
            }
            
        }
        .foregroundColor(Color.primary)
        .frame(height: 30)
        .frame(maxWidth: .infinity)
        
    }
}

#Preview {
    LegalOption(
        text: "Lorem ipsum",
        icon: "document.fill",
        action: {}
    )
}

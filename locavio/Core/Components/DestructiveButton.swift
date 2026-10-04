//
//  DestructiveButton.swift
//  locavio
//
//  Created by Julio Sampaio on 04/10/26.
//

import Foundation
import SwiftUI

struct DestructiveButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        
        Button(role: .destructive, action: action) {
            Text(text)
                .font(.headline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .clipShape(
                    RoundedRectangle(cornerRadius: 20)
                )
        }
        .buttonStyle(.glass)
        .foregroundColor(.red)

    }
}

#Preview {
    DestructiveButton(text: "Apagar", action: {})
}

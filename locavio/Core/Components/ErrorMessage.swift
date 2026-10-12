//
//  ErrorMessage.swift
//  locavio
//
//  Created by Julio Sampaio on 27/09/26.
//

import Foundation
import SwiftUI


struct ErrorMessage: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .font(.callout)
            .foregroundColor(.red)
            .fontWeight(.regular)
            .multilineTextAlignment(.leading)
    }
}

#Preview {
    ErrorMessage(text: "Lorem ipsum dolor")
}

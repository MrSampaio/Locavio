//
//  CreateTicketSheet.swift
//  locavio
//
//  Created by Julio Sampaio on 08/10/26.
//

import Foundation
import SwiftUI

struct CreateTicketSheet: View {
    
    var body: some View {
        textFields
    }
    
    @ViewBuilder
    var textFields: some View {
        Form {
            TextField("Título", text: .constant(""))
            TextField("Descrição", text: .constant(""))
        }
       
    }
}

#Preview {
    CreateTicketSheet()
}

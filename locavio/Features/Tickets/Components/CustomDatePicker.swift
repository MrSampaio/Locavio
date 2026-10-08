//
//  DatePicker.swift
//  locavio
//
//  Created by Julio Sampaio on 08/10/26.
//

import Foundation
import SwiftUI

struct CustomDatePicker: View {
    
    @Binding var date: Date
    @State var inputTitle: String = ""
    
    var body: some View {
        DatePicker("\(inputTitle)", selection: $date, displayedComponents: .date)
            .environment(\.locale, Locale(identifier: "pt_BR"))
    }
}

#Preview {
    CustomDatePicker(date: .constant(Date()))
}

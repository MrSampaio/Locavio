//
//  ProfileToolbar.swift
//  locavio
//
//  Created by Julio Sampaio on 29/09/26.
//

import Foundation
import SwiftUI

struct ProfileToolbar: ToolbarContent {
    var onClick: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: onClick) {
                Image(systemName: "square.and.pencil")
            }
        }
        
        
    }
}

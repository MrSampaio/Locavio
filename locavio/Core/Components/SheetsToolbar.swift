//
//  SheetsToolbar.swift
//  locavio
//
//  Created by Julio Sampaio on 04/10/26.
//

import Foundation
import SwiftUI

struct SheetsToolbar: ToolbarContent {
    var onConfirm: () -> Void
    var onClose: () -> Void
    var title: String?
    
    var body: some ToolbarContent {
        
        ToolbarItem(placement: .topBarLeading) {
            Button(action: onClose) {
                Image(systemName: "xmark")
            }
        }
        
        ToolbarItem(placement: .principal){
            Text(title ?? "")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: onConfirm) {
                Image(systemName: "checkmark")
                    .foregroundStyle(.white)
            }
            .buttonStyle(.glassProminent)
            
        }
    }
}

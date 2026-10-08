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
    var isDetail: Bool = false
    
    var body: some ToolbarContent {
        
        ToolbarItem(placement: .topBarLeading) {
            Button(action: onClose) {
                Image(
                    systemName: isDetail
                    ? "chevron.left"
                    : "xmark"
                )
            }
        }
        
        ToolbarItem(placement: .principal) {
            Text(title ?? "")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            if isDetail {
                
                Button(action: onConfirm) {
                    Image(systemName: "square.and.pencil")
                }
                
            } else {
                
                Button(action: onConfirm) {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.white)
                }
                .buttonStyle(.glassProminent)
            }
        }
    }
}

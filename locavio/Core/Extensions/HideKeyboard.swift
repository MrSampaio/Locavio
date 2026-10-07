//
//  HideKeyboard.swift
//  locavio
//
//  Created by Julio Sampaio on 07/10/26.
//

import Foundation
import SwiftUI
import UIKit

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

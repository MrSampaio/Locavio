//
//  SignUpViewModel.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation
import SwiftUI

@Observable
final class SignUpViewModel {
    var selectedDocumentType: DocumentTypeModel = .pf
    var documentNumber: String = ""
}

//
//  ProfileCoordinator.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftUI

@Observable
final class ProfileCoordinator {
    
    var path = NavigationPath()
    
    // controle das sheets
    var activeSheet: ProfileSheet?
    
    // navegação em pilha
    func pushToTerms() {
        path.append(ProfileRoutes.terms)
    }
    
    func pushToPrivacy() {
        path.append(ProfileRoutes.privacy)
    }
    
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    // navegação das sheets
    func presentEditProfile(user: Owner) {
        activeSheet = .editProfileSheet(user)
    }
    
    func dismissSheet() {
        activeSheet = nil
    }
}

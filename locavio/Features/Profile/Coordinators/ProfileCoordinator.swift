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
    func pushToProperties() {
        path.append(ProfileRoutes.properties)
    }
    
    func pushToDashboard() {
        path.append(ProfileRoutes.dashboard)
    }
    
    func pushToCalendar(){
        path.append(ProfileRoutes.calendar)
    }
    
    func pushToTickets(){
        path.append(ProfileRoutes.ticket)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    // navegação das sheets
    func presentEditProfile() {
        activeSheet = .editProfileSheet
    }
    
    func dismissSheet() {
        activeSheet = nil
    }
}

//
//  HomeViewModel.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI

@Observable
final class PropertiesViewModel{
    
    private let propertiesCoordinator = PropertiesCoordinator()
    
    var userName: String = ""
    var userEmail: String = ""
    
    init() {
        fetchUserData()
    }
    
    // função para puxar os dados do usuário
    func fetchUserData(){
        if let savedName = KeychainHelper.shared.readString(for: "appleUserFullName"), !savedName.isEmpty{
            self.userName = savedName
        } else{
            self.userName = "There is no username."
        }
        
        if let savedEmail = KeychainHelper.shared.readString(for: "appleUserEmail"), !savedEmail.isEmpty{
            self.userEmail = savedEmail
        } else{
            self.userEmail = "There is no user email."
        }
    }
    
    func addNewPropertyTapped() {
        propertiesCoordinator.pushToNewProperty()
    }
}


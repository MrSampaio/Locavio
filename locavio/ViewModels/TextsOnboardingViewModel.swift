//
//  TextsOnboarding.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 24/09/26.
//

import SwiftUI
import Observation

@Observable
@MainActor
final class TextsOnboardingViewModel {
    var currentScreen: Int = 0
    var finish: Bool = false
    
    let allScreen = 3
    
    let screenOnboardings: [TextsOnboardingModel] = [
        TextsOnboardingModel(titleOnboarding: "Gerencie seus imóveis", subtitleOnboarding: "Cadastre seus imóveis e tenha tudo organizado em um só lugar."),
        
        TextsOnboardingModel(titleOnboarding: "Acompanhe cada Solicitação", subtitleOnboarding: "Registre manutenções e acompanhe o andamento de tudo."),
        
        TextsOnboardingModel(titleOnboarding: "Tenha uma visão do seu negócio", subtitleOnboarding: "Acompanhe aluguéis, lucros e despesas em um único dashboard.")
    ]
    

    
    func continueOnboarding() {
        if currentScreen < allScreen - 1 {
            currentScreen += 1
            print(currentScreen)
        } else {
            finish = true
        }
    }
    
    func back() {
        guard currentScreen > 0 else { return }
        
        currentScreen -= 1
    }
}

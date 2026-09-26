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
    
    let screenOnboardings: [OnboardingModel] = [
        OnboardingModel(titleOnboarding: "Gerencie\nseus imóveis", subtitleOnboarding: "Cadastre seus imóveis e tenha tudo\norganizado em um só lugar.", image: "OnboardingScreen1"),
        
        OnboardingModel(titleOnboarding: "Acompanhe\ncada Solicitação", subtitleOnboarding: "Registre manutenções e acompanhe o\nandamento de tudo.", image: "OnboardingScreen2"),
        
        OnboardingModel(titleOnboarding: "Tenha uma\n visão do seu negócio", subtitleOnboarding: "Acompanhe aluguéis, lucros e despesas\nem um único dashboard.", image: "OnboardingScreen3")
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

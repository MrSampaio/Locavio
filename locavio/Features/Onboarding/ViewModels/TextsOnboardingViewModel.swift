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

    /// Direção da última navegação (a tela usa para escolher o lado da animação).
    var isGoingForward: Bool = true

    let allScreen = 3

    let screenOnboardings: [OnboardingModel] = [
        OnboardingModel(titleOnboarding: "Gerencie\nseus imóveis", subtitleOnboarding: "Cadastre seus imóveis e tenha tudo\norganizado em um só lugar.", image: "OnboardingScreen1"),

        OnboardingModel(titleOnboarding: "Acompanhe\ncada Solicitação", subtitleOnboarding: "Registre manutenções e acompanhe o\nandamento de tudo.", image: "OnboardingScreen2"),

        OnboardingModel(titleOnboarding: "Tenha uma\n visão do seu negócio", subtitleOnboarding: "Acompanhe aluguéis, lucros e despesas\nem um único dashboard.", image: "OnboardingScreen3")
    ]

    func continueOnboarding() {
        isGoingForward = true

        // pequena pausa: a direção precisa ser aplicada antes da troca de tela
        Task {
            try? await Task.sleep(for: .milliseconds(20))

            if currentScreen < allScreen - 1 {
                currentScreen += 1
            } else {
                finish = true
            }
        }
    }

    func back() {
        guard currentScreen > 0 else { return }
        isGoingForward = false

        Task {
            try? await Task.sleep(for: .milliseconds(20))

            guard currentScreen > 0 else { return }
            currentScreen -= 1
        }
    }

    // não é push ou pop, ele troca a raiz do app inteiro
    func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "onboardingConcluido")
    }
}

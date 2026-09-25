//
//  OnboardingCoordinatorView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 25/09/26.
//

import SwiftUI


import SwiftData

struct OnboardingCoordinatorView: View {
    @Environment(\.modelContext) private var context
    @AppStorage("onboardingConcluido") private var onboardingConcluido: Bool = false

    var body: some View {
        Group {
            if onboardingConcluido {
                LoginView()
            } else {
                OnboardingView()
            }
        }
    }
}

//#Preview {
//    OnboardingCoordinatorView()
//}

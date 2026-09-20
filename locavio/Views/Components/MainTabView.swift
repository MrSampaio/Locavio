//
//  MainTabView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            PropertiesCoordinatorView()
                .tabItem {
                    Label("Imóveis", systemImage: "house")
                }
             // adiciona depois as outras views aqui
            
            
        }
    }
}

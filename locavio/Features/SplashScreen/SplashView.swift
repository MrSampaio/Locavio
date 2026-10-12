//
//  SplashView.swift
//  locavio
//
//  Created by Julio Sampaio on 06/10/26.
//

import Foundation
import SwiftUI

struct SplashView: View {
    var onFinish: () -> Void = {}
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .center){
            
            
            Color(.appBg)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {
                
                if(colorScheme == .dark){
                    VideoPlayerView(
                        fileName: "locavio_dark",
                        fileExtension: "mov",
                        onFinish: onFinish
                    )
                    .frame(width: 300, height: 300)
                } else{
                    VideoPlayerView(
                        fileName: "locavio_white",
                        fileExtension: "mov",
                        onFinish: onFinish
                    )
                    .frame(width: 300, height: 300)
                }
               
            }
            .padding(.bottom, 80)
        }
        .task {
            try? await Task.sleep(for: .milliseconds(1350))
            SoundManager.shared.playSound(named: .splash)
        }
        
        
    }
}

#Preview {
    SplashView()
}

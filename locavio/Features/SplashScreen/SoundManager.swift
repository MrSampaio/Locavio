//
//  SoundManager.swift
//  locavio
//
//  Created by Julio Sampaio on 06/10/26.
//

import Foundation
import AVFoundation


class SoundManager {
    static let shared = SoundManager()
    private var audioPlayer: AVAudioPlayer?
    
    enum SoundType {
        case splash
        
        var fileName: (name: String, extension: String) {
            switch self {
                case .splash: return ("ding-dong", "mp3")
            }
        }
    }
    
    func playSound(named sound: SoundType) {
        let file = sound.fileName
        
        guard let url = Bundle.main.url(forResource: file.name, withExtension: file.extension) else {
            print("File '\(file.name).\(file.extension)' not founded")
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOf: url)
                self.audioPlayer?.prepareToPlay()
                self.audioPlayer?.play()
            } catch {
                print("Error when reproducing sound: \(error.localizedDescription)")
            }
        }
    }
}

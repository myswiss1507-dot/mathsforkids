import AVFoundation
import SwiftUI

class SoundManager {
    static let shared = SoundManager()
    
    private var correctPlayer: AVAudioPlayer?
    private var wrongPlayer: AVAudioPlayer?
    
    private init() {
        setupAudioSession()
        setupSystemSounds()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    private func setupSystemSounds() {
        // Since we're using system sounds, we'll use AVAudioPlayer with generated sounds
        // or system sound IDs
    }
    
    func playWelcomeSound() {
        // Play a cheerful welcome sound
        AudioServicesPlaySystemSound(1054) // Welcome/notification sound
        
        // Add happy haptic
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    

    
    func playCorrectSound() {
        // Play a pleasant "correct" sound
        // Using system sound for success
        AudioServicesPlaySystemSound(1057) // Tink sound
        
        // Optional: Add haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func playWrongSound() {
        // Play a gentle "try again" sound
        // Using system sound for error
        AudioServicesPlaySystemSound(1053) // Pop sound (subtle)
        
        // Optional: Add haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    func playButtonTap() {
        // Subtle tap sound
        AudioServicesPlaySystemSound(1104) // Keyboard tap
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

// Extension to make it easy to use in SwiftUI
extension View {
    func onCorrectAnswer() -> some View {
        self.onAppear {
            SoundManager.shared.playCorrectSound()
        }
    }
    
    func onWrongAnswer() -> some View {
        self.onAppear {
            SoundManager.shared.playWrongSound()
        }
    }
}

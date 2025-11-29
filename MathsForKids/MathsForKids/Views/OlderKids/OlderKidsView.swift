import SwiftUI
import Combine

struct OlderKidsView: View {
    @StateObject private var gameManager = GameManager()
    private let soundManager = SoundManager.shared
    @State private var timeRemaining = 60
    @State private var timerActive = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Theme.Colors.olderKidsBackground.ignoresSafeArea()
            
            // Background particles or shapes could go here
            
            VStack(spacing: 20) {
                HStack {
                    ScoreView(score: gameManager.score, highScore: gameManager.highScore, currentStreak: gameManager.currentStreak)
                    
                    Spacer()
                    
                    QuestionProgressView(
                        questionsAnswered: gameManager.questionsAnswered
                    )
                    
                    Spacer()
                    
                    VStack {
                        Text("game.time.label".localized)
                            .font(Theme.Fonts.body(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                        Text("\(timeRemaining)")
                            .font(Theme.Fonts.title(size: 30))
                            .foregroundColor(timeRemaining < 10 ? .red : .white)
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(15)
                    
                    GameExitButton {
                        gameManager.resetGame()
                        dismiss()
                    }
                    .padding(.leading, 10)
                }
                .padding(.horizontal)
                
                Spacer()
                
                if !gameManager.isGameOver {
                    if let question = gameManager.currentQuestion {
                        Text(question.text)
                            .font(.system(size: 80, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                        
                        Spacer()
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(question.options, id: \.self) { option in
                                GameButton(title: "\(option)", color: .white.opacity(0.2)) {
                                    let result = gameManager.checkAnswer(option)
                                    if result.correct {
                                        soundManager.playCorrectSound()
                                        gameManager.generateQuestion(for: .olderKids)
                                    } else {
                                        soundManager.playWrongSound()
                                        // Penalty for wrong answer
                                        timeRemaining = max(0, timeRemaining - 5)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            startGame()
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            guard timerActive && !gameManager.isGameOver else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                gameManager.isGameOver = true
                timerActive = false
            }
        }
        .overlay(
            Group {
                if gameManager.isGameOver {
                    GameOverView(
                        score: gameManager.score,
                        questionsAnswered: gameManager.questionsAnswered,
                        highScore: gameManager.highScore,
                        onPlayAgain: {
                            resetGame()
                        },
                        onExit: {
                            dismiss()
                        }
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
        )
    }
    
    func startGame() {
        gameManager.resetGame()
        gameManager.generateQuestion(for: .olderKids)
        timeRemaining = 60
        timerActive = true
    }
    
    func resetGame() {
        startGame()
    }
}

struct OlderKidsView_Previews: PreviewProvider {
    static var previews: some View {
        OlderKidsView()
    }
}

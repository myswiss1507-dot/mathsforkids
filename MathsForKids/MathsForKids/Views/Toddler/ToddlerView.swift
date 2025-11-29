import SwiftUI

struct ToddlerView: View {
    @StateObject private var gameManager = GameManager()
    private let soundManager = SoundManager.shared
    @State private var showSuccess = false
    @Environment(\.dismiss) private var dismiss
    
    let animals = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼"]
    
    var body: some View {
        ZStack {
            Theme.Colors.toddlerBackground.ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    ScoreView(score: gameManager.score, highScore: gameManager.highScore, currentStreak: gameManager.currentStreak)
                    Spacer()
                    QuestionProgressView(
                        questionsAnswered: gameManager.questionsAnswered
                    )
                    .padding(.trailing, 10)
                    
                    GameExitButton {
                        gameManager.resetGame()
                        dismiss()
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Text("toddler.title".localized)
                    .font(Theme.Fonts.title(size: 30))
                    .foregroundColor(.purple)
                
                if let question = gameManager.currentQuestion {
                    HStack {
                        ForEach(0..<question.answer, id: \.self) { _ in
                            Text(animals.randomElement()!)
                                .font(.system(size: 60))
                                .transition(.scale)
                        }
                    }
                    .padding(30)
                    .background(Color.white)
                    .cornerRadius(30)
                    .neumorphicShadow()
                    .padding()
                    
                    Spacer()
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                        ForEach(question.options, id: \.self) { option in
                            Button(action: {
                                let result = gameManager.checkAnswer(option)
                                if result.correct {
                                    soundManager.playCorrectSound()
                                    showSuccess = true
                                    
                                    // Store bonus state if needed for custom message
                                    // For now, we rely on the appreciation message or could add a specific "Fast!" overlay
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        showSuccess = false
                                        gameManager.generateQuestion(for: .toddler)
                                    }
                                } else {
                                    soundManager.playWrongSound()
                                }
                            }) {
                                Text("\(option)")
                                    .font(Theme.Fonts.gameNumber())
                                    .frame(width: 100, height: 100)
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                                    .neumorphicShadow(color: .orange)
                            }
                            .buttonStyle(ScaleButtonStyle())
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
        }
        .onAppear {
            gameManager.generateQuestion(for: .toddler)
        }
        .overlay(
            Group {
                if showSuccess {
                    let message = gameManager.getAppreciationMessage() ?? "toddler.success".localized
                    Text(message)
                        .font(Theme.Fonts.title(size: 50))
                        .padding(40)
                        .background(Color.white)
                        .cornerRadius(30)
                        .neumorphicShadow()
                        .transition(.scale.combined(with: .opacity))
                        .zIndex(1)
                }
            }
        )
        .overlay(
            Group {
                if gameManager.isGameOver {
                    GameOverView(
                        score: gameManager.score,
                        questionsAnswered: gameManager.questionsAnswered,
                        highScore: gameManager.highScore,
                        onPlayAgain: {
                            gameManager.resetGame()
                            gameManager.generateQuestion(for: .toddler)
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
}

struct ToddlerView_Previews: PreviewProvider {
    static var previews: some View {
        ToddlerView()
    }
}

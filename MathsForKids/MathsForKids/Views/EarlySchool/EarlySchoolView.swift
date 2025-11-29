import SwiftUI

struct EarlySchoolView: View {
    @StateObject private var gameManager = GameManager()
    private let soundManager = SoundManager.shared
    @State private var feedbackMessage: String?
    @State private var animateFeedback = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Theme.Colors.earlySchoolBackground.ignoresSafeArea()
            
            VStack(spacing: 30) {
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
                
                if let question = gameManager.currentQuestion {
                    Text(question.text)
                        .font(.system(size: 80, weight: .bold, design: .monospaced))
                        .padding(40)
                        .background(Color.white)
                        .cornerRadius(30)
                        .neumorphicShadow()
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        ForEach(question.options, id: \.self) { option in
                            GameButton(title: "\(option)", color: .blue) {
                                let result = gameManager.checkAnswer(option)
                                if result.correct {
                                    soundManager.playCorrectSound()
                                    
                                    // Check for appreciation message or bonus
                                    if result.bonus {
                                        feedbackMessage = "bonus.fast".localized
                                    } else if let appreciation = gameManager.getAppreciationMessage() {
                                        feedbackMessage = appreciation
                                    } else {
                                        feedbackMessage = "feedback.correct".localized
                                    }
                                    
                                    animateFeedback = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        feedbackMessage = nil
                                        animateFeedback = false
                                        gameManager.generateQuestion(for: .earlySchool)
                                    }
                                } else {
                                    soundManager.playWrongSound()
                                    feedbackMessage = "feedback.wrong".localized
                                    animateFeedback = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        feedbackMessage = nil
                                        animateFeedback = false
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
        }
        .onAppear {
            gameManager.generateQuestion(for: .earlySchool)
        }
        .overlay(
            Group {
                if let message = feedbackMessage {
                    Text(message)
                        .font(Theme.Fonts.title())
                        .padding()
                        .background(Color.white.opacity(0.95))
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .scaleEffect(animateFeedback ? 1.1 : 0.5)
                        .animation(.spring(), value: animateFeedback)
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
                            gameManager.generateQuestion(for: .earlySchool)
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

struct EarlySchoolView_Previews: PreviewProvider {
    static var previews: some View {
        EarlySchoolView()
    }
}

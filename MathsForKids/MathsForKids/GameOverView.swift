import SwiftUI

struct GameOverView: View {
    let score: Int
    let questionsAnswered: Int
    let highScore: Int
    let onPlayAgain: () -> Void
    let onExit: () -> Void
    
    var percentage: Double {
        guard questionsAnswered > 0 else { return 0 }
        return Double(score) / Double(questionsAnswered) * 100
    }
    
    var performanceMessage: String {
        if percentage == 100 {
            return "game.over.perfect".localized
        } else if percentage >= 80 {
            return "game.over.excellent".localized
        } else if percentage >= 60 {
            return "game.over.great".localized
        } else if percentage >= 40 {
            return "game.over.good".localized
        } else {
            return "game.over.practice".localized
        }
    }
    
    var performanceEmoji: String {
        if percentage == 100 {
            return "🏆"
        } else if percentage >= 80 {
            return "⭐️"
        } else if percentage >= 60 {
            return "😊"
        } else if percentage >= 40 {
            return "🙂"
        } else {
            return "💪"
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text(performanceMessage)
                    .font(Theme.Fonts.title(size: 40))
                    .foregroundColor(.primary)
                
                Text(performanceEmoji)
                    .font(.system(size: 100))
                
                VStack(spacing: 15) {
                    Text("game.over.your_score".localized)
                        .font(Theme.Fonts.title(size: 24))
                        .foregroundColor(.secondary)
                    
                    Text("\(score) / \(questionsAnswered)")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("\(Int(percentage))%")
                        .font(.system(size: 40, weight: .semibold, design: .rounded))
                        .foregroundColor(.green)
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(20)
                
                if score == highScore && score > 0 {
                    Text("game.over.new_high_score".localized)
                        .font(Theme.Fonts.title(size: 24))
                        .foregroundColor(.yellow)
                        .padding()
                        .background(Color.orange.opacity(0.3))
                        .cornerRadius(15)
                }
                
                VStack(spacing: 15) {
                    Button(action: onPlayAgain) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("game.over.play_again".localized)
                        }
                        .font(Theme.Fonts.title(size: 24))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .background(Color.green)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                    }
                    .buttonStyle(ScaleButtonStyle())
                    
                    Button(action: onExit) {
                        HStack {
                            Image(systemName: "house.fill")
                            Text("game.over.exit".localized)
                        }
                        .font(Theme.Fonts.title(size: 20))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .background(Color.gray)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
            .padding(40)
            .background(Color.white)
            .cornerRadius(30)
            .shadow(radius: 20)
            .padding(30)
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(score: 8, questionsAnswered: 10, highScore: 9, onPlayAgain: {}, onExit: {})
    }
}

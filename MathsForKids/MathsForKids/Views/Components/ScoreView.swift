import SwiftUI

struct ScoreView: View {
    let score: Int
    let highScore: Int
    let currentStreak: Int
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("game.score".localized)
                    .font(Theme.Fonts.body(size: 14))
                    .foregroundColor(.secondary)
                Text("\(score)")
                    .font(Theme.Fonts.title(size: 24))
                    .foregroundColor(.primary)
            }
            
            // Show streak if 3 or more
            if currentStreak >= 3 {
                Divider()
                    .frame(height: 40)
                
                VStack(alignment: .center, spacing: 2) {
                    Text("🔥")
                        .font(.system(size: 20))
                    Text("\(currentStreak)")
                        .font(Theme.Fonts.title(size: 24))
                        .foregroundColor(.orange)
                }
            }
            
            Spacer()
            
            if highScore > 0 {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("game.best".localized)
                        .font(Theme.Fonts.body(size: 14))
                        .foregroundColor(.secondary)
                    Text("\(highScore)")
                        .font(Theme.Fonts.title(size: 24))
                        .foregroundColor(.orange)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(15)
        .neumorphicShadow()
    }
}

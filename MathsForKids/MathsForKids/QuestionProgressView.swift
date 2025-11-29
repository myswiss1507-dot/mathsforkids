import SwiftUI

struct QuestionProgressView: View {
    let questionsAnswered: Int
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(questionsAnswered)")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text("Questions")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.black.opacity(0.3))
        .cornerRadius(15)
    }
}

struct QuestionProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue
            QuestionProgressView(questionsAnswered: 15)
        }
    }
}

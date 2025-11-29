import SwiftUI

struct SessionDetailView: View {
    let session: GameSession
    
    var body: some View {
        List {
            Section(header: Text("parent.report.summary".localized)) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("game.score".localized)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(session.score)/\(session.questionsAnswered)")
                            .font(.headline)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("parent.report.accuracy".localized)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(String(format: "%.0f%%", session.accuracy))
                            .font(.headline)
                            .foregroundColor(color(for: session.accuracy))
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("parent.report.duration".localized)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(session.formattedDuration)
                            .font(.headline)
                    }
                }
                .padding(.vertical, 8)
            }
            
            Section(header: Text("parent.report.details".localized)) {
                if session.details.isEmpty {
                    Text("parent.report.no_details".localized)
                        .foregroundColor(.secondary)
                } else {
                    ForEach(session.details) { detail in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(detail.questionText)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Text("parent.report.correct_answer".localized + ": \(detail.correctAnswer)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                HStack(spacing: 4) {
                                    Image(systemName: "clock")
                                        .font(.caption2)
                                    Text(detail.formattedTime)
                                        .font(.subheadline)
                                }
                                .foregroundColor(.secondary)
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                        .font(.caption2)
                                    Text("\(detail.attempts) " + "parent.report.attempts".localized)
                                        .font(.caption)
                                }
                                .foregroundColor(detail.attempts == 1 ? .green : .orange)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle(session.formattedDate)
    }
    
    private func color(for accuracy: Double) -> Color {
        switch accuracy {
        case 90...100: return .green
        case 70..<90: return .blue
        case 50..<70: return .orange
        default: return .red
        }
    }
}

struct SessionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SessionDetailView(session: GameSession(
            date: Date(),
            difficulty: "Toddler",
            score: 8,
            questionsAnswered: 10,
            duration: 120,
            details: [
                QuestionPerformance(questionText: "5 + 3", correctAnswer: "8", timeTaken: 2.5, attempts: 1, isCorrect: true),
                QuestionPerformance(questionText: "10 - 2", correctAnswer: "8", timeTaken: 5.0, attempts: 2, isCorrect: true)
            ]
        ))
    }
}

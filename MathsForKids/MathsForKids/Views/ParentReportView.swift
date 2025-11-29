import SwiftUI

import UIKit
struct ParentReportView: View {
    @ObservedObject var gameManager = GameManager()
    @Environment(\.dismiss) var dismiss
    @State private var showShareSheet = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("parent.report.summary".localized)) {
                    if gameManager.recentSessions.isEmpty {
                        Text("parent.report.no_games".localized)
                            .foregroundColor(.secondary)
                    } else {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("parent.report.total_sessions".localized)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(gameManager.recentSessions.count)")
                                    .font(.headline)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("parent.report.total_questions".localized)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(totalQuestions)")
                                    .font(.headline)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("parent.report.accuracy".localized)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(String(format: "%.1f%%", averageAccuracy))
                                    .font(.headline)
                                    .foregroundColor(accuracyColor)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                if !gameManager.recentSessions.isEmpty {
                    Section(header: Text("parent.report.recent_history".localized)) {
                        ForEach(gameManager.recentSessions) { session in
                            NavigationLink(destination: SessionDetailView(session: session)) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(session.formattedDate)
                                            .font(.headline)
                                        Text(session.difficulty)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("\(session.score)/\(session.questionsAnswered)")
                                            .fontWeight(.bold)
                                            .foregroundColor(color(for: session.accuracy))
                                        
                                        Text(session.formattedDuration)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
            }
            .navigationTitle("parent.report.title".localized)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("parent.report.done".localized)
                            .fontWeight(.bold)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        if !gameManager.recentSessions.isEmpty {
                            Button(action: {
                                showShareSheet = true
                            }) {
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: [gameManager.generateReport()])
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var totalQuestions: Int {
        gameManager.recentSessions.reduce(0) { $0 + $1.questionsAnswered }
    }
    
    private var averageAccuracy: Double {
        guard totalQuestions > 0 else { return 0 }
        let totalScore = gameManager.recentSessions.reduce(0) { $0 + $1.score }
        return Double(totalScore) / Double(totalQuestions) * 100
    }
    
    private var accuracyColor: Color {
        color(for: averageAccuracy)
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

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct ParentReportView_Previews: PreviewProvider {
    static var previews: some View {
        ParentReportView()
    }
}

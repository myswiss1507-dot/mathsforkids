import Foundation
import Combine

class GameManager: ObservableObject {
    @Published var score = 0
    @Published var currentQuestion: Question?
    @Published var isGameOver = false
    @Published var highScore = 0
    @Published var currentQuestionNumber = 0
    @Published var questionsAnswered = 0  // Total questions answered (no limit)
    @Published var currentStreak = 0  // Current streak of correct answers
    @Published var bestStreak = 0  // Best streak in this session
    
    @Published var recentSessions: [GameSession] = []
    
    private var currentDifficulty: Difficulty = .toddler
    private var questionSet: QuestionSet?
    private var askedQuestions: [Question] = []
    private var startTime: Date?
    
    enum Difficulty: String, Codable {
        case toddler
        case earlySchool
        case olderKids
        
        var displayName: String {
            switch self {
            case .toddler: return "Toddler"
            case .earlySchool: return "Early School"
            case .olderKids: return "Older Kids"
            }
        }
    }
    
    private var currentQuestionAttempts = 0
    private var sessionPerformance: [QuestionPerformance] = []
    
    init() {
        loadSessions()
    }
    
    private var questionStartTime: Date?
    
    // ... (existing code)
    
    func generateQuestion(for difficulty: Difficulty) {
        self.currentDifficulty = difficulty
        loadHighScore()
        
        if startTime == nil {
            startTime = Date()
        }
        
        questionStartTime = Date()
        
        // Initialize question set if not already done
        if questionSet == nil || questionSet?.difficulty != difficulty {
            questionSet = QuestionSet.generateSet(for: difficulty)
            askedQuestions = []
            currentQuestionNumber = 0
        }
        
        guard let set = questionSet else { return }
        
        // Cycle through questions infinitely - loop back to start when reaching the end
        if currentQuestionNumber >= set.questions.count {
            currentQuestionNumber = 0
            // Optionally shuffle questions for variety
        }
        
        // Get the next question from the set
        currentQuestion = set.questions[currentQuestionNumber]
        currentQuestionNumber += 1
        questionsAnswered += 1
        currentQuestionAttempts = 0
    }
    
    func checkAnswer(_ selectedAnswer: Int) -> (correct: Bool, bonus: Bool) {
        guard let question = currentQuestion else { return (false, false) }
        
        currentQuestionAttempts += 1
        
        if selectedAnswer == question.answer {
            var pointsToAdd = 1
            var isBonus = false
            var timeTaken: TimeInterval = 0
            
            // Check for speed bonus
            if let qStart = questionStartTime {
                timeTaken = Date().timeIntervalSince(qStart)
                let threshold: TimeInterval = currentDifficulty == .olderKids ? 3.0 : 5.0
                
                if timeTaken <= threshold {
                    pointsToAdd += 1 // Bonus point
                    isBonus = true
                }
            }
            
            // Record performance
            let performance = QuestionPerformance(
                questionText: question.text,
                correctAnswer: "\(question.answer)",
                timeTaken: timeTaken,
                attempts: currentQuestionAttempts,
                isCorrect: true
            )
            sessionPerformance.append(performance)
            
            score += pointsToAdd
            currentStreak += 1
            
            // Update best streak
            if currentStreak > bestStreak {
                bestStreak = currentStreak
            }
            
            if score > highScore {
                highScore = score
                saveHighScore()
            }
            return (true, isBonus)
        } else {
            // Reset streak on wrong answer
            currentStreak = 0
            return (false, false)
        }
    }
    
    // Get appreciation message based on streak
    func getAppreciationMessage() -> String? {
        switch currentStreak {
        case 3:
            return "appreciation.streak3".localized
        case 5:
            return "appreciation.streak5".localized
        case 10:
            return "appreciation.streak10".localized
        case 15:
            return "appreciation.streak15".localized
        case 20:
            return "appreciation.streak20".localized
        case 25, 30, 35, 40, 45, 50:
            return "appreciation.streak_amazing".localized
        default:
            return nil
        }
    }
    
    func resetGame() {
        saveSession()
        score = 0
        isGameOver = false
        currentQuestion = nil
        currentQuestionNumber = 0
        questionsAnswered = 0
        currentStreak = 0
        bestStreak = 0
        questionSet = nil
        askedQuestions = []
        startTime = nil
        sessionPerformance = []
        loadHighScore()
    }
    
    private func loadHighScore() {
        highScore = UserDefaults.standard.integer(forKey: "HighScore_\(currentDifficulty.rawValue)")
    }
    
    private func saveHighScore() {
        UserDefaults.standard.set(highScore, forKey: "HighScore_\(currentDifficulty.rawValue)")
    }
    
    // MARK: - Session Management
    private func saveSession() {
        guard questionsAnswered > 0, let start = startTime else { return }
        
        let session = GameSession(
            date: Date(),
            difficulty: currentDifficulty.displayName,
            score: score,
            questionsAnswered: questionsAnswered,
            duration: Date().timeIntervalSince(start),
            details: sessionPerformance
        )
        
        recentSessions.insert(session, at: 0)
        // Keep only last 50 sessions
        if recentSessions.count > 50 {
            recentSessions = Array(recentSessions.prefix(50))
        }
        
        if let encoded = try? JSONEncoder().encode(recentSessions) {
            UserDefaults.standard.set(encoded, forKey: "GameSessions")
        }
    }
    
    private func loadSessions() {
        if let data = UserDefaults.standard.data(forKey: "GameSessions") {
            do {
                recentSessions = try JSONDecoder().decode([GameSession].self, from: data)
            } catch {
                // Failed to decode sessions
            }
        }
    }
    
    func generateReport() -> String {
        var report = "parent.report.share_title".localized + "\n"
        report += "parent.report.generated_on".localized + ": \(Date().formatted(date: .long, time: .shortened))\n\n"
        
        if recentSessions.isEmpty {
            report += "parent.report.no_games".localized
            return report
        }
        
        // Summary Stats
        let totalSessions = recentSessions.count
        let totalQuestions = recentSessions.reduce(0) { $0 + $1.questionsAnswered }
        let totalScore = recentSessions.reduce(0) { $0 + $1.score }
        let averageAccuracy = totalQuestions > 0 ? (Double(totalScore) / Double(totalQuestions) * 100) : 0
        
        report += "parent.report.summary_header".localized + ":\n"
        report += "parent.report.total_sessions".localized + ": \(totalSessions)\n"
        report += "parent.report.total_questions".localized + ": \(totalQuestions)\n"
        report += "parent.report.accuracy".localized + ": \(String(format: "%.1f", averageAccuracy))%\n\n"
        
        report += "parent.report.recent_sessions_header".localized + ":\n"
        for session in recentSessions.prefix(10) {
            report += "- \(session.formattedDate) (\(session.difficulty))\n"
            report += "  " + "game.score".localized + ": \(session.score)/\(session.questionsAnswered) (\(String(format: "%.0f", session.accuracy))%)\n"
            report += "  " + "parent.report.duration".localized + ": \(session.formattedDuration)\n\n"
        }
        
        return report
    }
}

import Foundation

struct GameSession: Codable, Identifiable {
    var id = UUID()
    let date: Date
    let difficulty: String
    let score: Int
    let questionsAnswered: Int
    let duration: TimeInterval
    
    var accuracy: Double {
        guard questionsAnswered > 0 else { return 0 }
        return Double(score) / Double(questionsAnswered) * 100
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    // Default empty for backward compatibility
    var details: [QuestionPerformance] = []
    
    enum CodingKeys: String, CodingKey {
        case id, date, difficulty, score, questionsAnswered, duration, details
    }
    
    init(date: Date, difficulty: String, score: Int, questionsAnswered: Int, duration: TimeInterval, details: [QuestionPerformance] = []) {
        self.date = date
        self.difficulty = difficulty
        self.score = score
        self.questionsAnswered = questionsAnswered
        self.duration = duration
        self.details = details
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        difficulty = try container.decode(String.self, forKey: .difficulty)
        score = try container.decode(Int.self, forKey: .score)
        questionsAnswered = try container.decode(Int.self, forKey: .questionsAnswered)
        duration = try container.decode(TimeInterval.self, forKey: .duration)
        details = try container.decodeIfPresent([QuestionPerformance].self, forKey: .details) ?? []
    }
}

struct QuestionPerformance: Codable, Identifiable {
    var id = UUID()
    let questionText: String
    let correctAnswer: String
    let timeTaken: TimeInterval
    let attempts: Int
    let isCorrect: Bool
    
    var formattedTime: String {
        return String(format: "%.1fs", timeTaken)
    }
}

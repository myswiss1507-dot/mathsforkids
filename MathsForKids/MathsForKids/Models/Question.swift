import Foundation
enum Operation: String, CaseIterable {
    case addition = "+"
    case subtraction = "-"
    case multiplication = "×"
    case division = "÷"
}

struct Question: Identifiable {
    let id = UUID()
    let textKey: String  // Localization key
    let answer: Int
    let options: [Int]
    let operation: Operation
    
    // Computed property for localized text
    var text: String {
        return textKey.localized
    }
    
    // Convenience initializer for backward compatibility
    init(text: String, answer: Int, options: [Int], operation: Operation) {
        self.textKey = text
        self.answer = answer
        self.options = options
        self.operation = operation
    }
}

import Foundation

struct QuestionSet {
    let difficulty: GameManager.Difficulty
    let questions: [Question]
    
    static func generateSet(for difficulty: GameManager.Difficulty) -> QuestionSet {
        let questions: [Question]
        
        switch difficulty {
        case .toddler:
            questions = toddlerQuestions()
        case .earlySchool:
            questions = earlySchoolQuestions()
        case .olderKids:
            questions = olderKidsQuestions()
        }
        
        return QuestionSet(difficulty: difficulty, questions: questions)
    }
    
    // MARK: - Toddler Questions (Ages 2-4)
    // Focus: Counting 1-10 (curriculum standard: count to 10 by age 4)
    // Generates 300 random questions
    private static func toddlerQuestions() -> [Question] {
        var questions: [Question] = []
        
        for _ in 0..<300 {
            // Weighted random: more 1-5 (60%), less 6-10 (40%)
            let answer: Int
            if Bool.random() && Bool.random() { // ~25% chance for 6-10? No, let's do simple random for now but ensure coverage
                answer = Int.random(in: 1...10)
            } else {
                answer = Int.random(in: 1...10)
            }
            
            // Generate distinct options
            var options = Set<Int>()
            options.insert(answer)
            while options.count < 3 {
                let distractor = Int.random(in: 1...10)
                options.insert(distractor)
            }
            
            questions.append(Question(
                text: "toddler.question",
                answer: answer,
                options: Array(options).shuffled(),
                operation: .addition // Conceptually counting is adding 1s
            ))
        }
        
        return questions
    }
    
    // MARK: - Early School Questions (Ages 5-7)
    // Focus: Addition and Subtraction within 20
    // Generates 400 random questions
    private static func earlySchoolQuestions() -> [Question] {
        var questions: [Question] = []
        
        for _ in 0..<400 {
            let isAddition = Bool.random()
            let text: String
            let answer: Int
            
            if isAddition {
                // a + b = answer (max 20)
                let a = Int.random(in: 1...10)
                let b = Int.random(in: 1...10)
                answer = a + b
                text = "\(a) + \(b)"
            } else {
                // a - b = answer (non-negative)
                let a = Int.random(in: 2...20)
                let b = Int.random(in: 1..<a) // Ensure positive result
                answer = a - b
                text = "\(a) - \(b)"
            }
            
            // Generate distinct options (close to answer)
            var options = Set<Int>()
            options.insert(answer)
            while options.count < 3 {
                // Distractors within +/- 3 of answer, but non-negative
                let offset = Int.random(in: -3...3)
                let distractor = answer + offset
                if distractor >= 0 && distractor != answer {
                    options.insert(distractor)
                }
            }
            
            questions.append(Question(
                text: text,
                answer: answer,
                options: Array(options).shuffled(),
                operation: isAddition ? .addition : .subtraction
            ))
        }
        
        return questions
    }
    
    // MARK: - Older Kids Questions (Ages 8-12)
    // Focus: Multiplication and Division tables 2-12
    // Generates 400 random questions
    private static func olderKidsQuestions() -> [Question] {
        var questions: [Question] = []
        
        for _ in 0..<400 {
            let isMultiplication = Bool.random()
            let text: String
            let answer: Int
            
            if isMultiplication {
                // a × b = answer
                let a = Int.random(in: 2...12)
                let b = Int.random(in: 2...12)
                answer = a * b
                text = "\(a) × \(b)"
            } else {
                // product ÷ divisor = quotient
                let divisor = Int.random(in: 2...12)
                let quotient = Int.random(in: 2...12)
                let dividend = divisor * quotient
                answer = quotient
                text = "\(dividend) ÷ \(divisor)"
            }
            
            // Generate distinct options
            var options = Set<Int>()
            options.insert(answer)
            while options.count < 4 { // 4 options for older kids
                // Distractors: close numbers or multiples
                let strategy = Int.random(in: 0...2)
                var distractor = 0
                
                if strategy == 0 {
                    // Close number (+/- 1-5)
                    distractor = answer + Int.random(in: -5...5)
                } else {
                    // Wrong multiple (e.g. if answer is 6x7=42, maybe 6x6=36 or 6x8=48)
                    // Simplified: just random close number for now to ensure validity
                     distractor = answer + Int.random(in: -10...10)
                }
                
                if distractor > 0 && distractor != answer {
                    options.insert(distractor)
                }
            }
            
            questions.append(Question(
                text: text,
                answer: answer,
                options: Array(options).shuffled(),
                operation: isMultiplication ? .multiplication : .division
            ))
        }
        
        return questions
    }
}

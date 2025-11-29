import SwiftUI

enum Gender: String, CaseIterable {
    case boy = "Boy"
    case girl = "Girl"
    
    var localizedName: String {
        switch self {
        case .boy: return "gender.boy".localized
        case .girl: return "gender.girl".localized
        }
    }
    
    var emoji: String {
        switch self {
        case .boy: return "👦"
        case .girl: return "👧"
        }
    }
    
    var primaryColor: Color {
        switch self {
        case .boy: return .blue
        case .girl: return .pink
        }
    }
    
    var secondaryColor: Color {
        switch self {
        case .boy: return .cyan
        case .girl: return Color(red: 1.0, green: 0.75, blue: 0.8)
        }
    }
    
    var backgroundColor: LinearGradient {
        switch self {
        case .boy:
            return LinearGradient(
                colors: [Color.blue.opacity(0.6), Color.cyan.opacity(0.4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .girl:
            return LinearGradient(
                colors: [Color.pink.opacity(0.6), Color(red: 1.0, green: 0.85, blue: 0.9)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

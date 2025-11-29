import SwiftUI

struct Theme {
    struct Colors {
        // Fresh, vibrant landing page background - Tropical Sunrise
        static let background = LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 1.0, green: 0.4, blue: 0.5),   // Coral pink
                Color(red: 1.0, green: 0.7, blue: 0.3),   // Warm orange
                Color(red: 0.4, green: 0.8, blue: 1.0)    // Sky blue
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Toddler - Cotton Candy Dream
        static let toddlerBackground = LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 1.0, green: 0.6, blue: 0.8),   // Bubblegum pink
                Color(red: 0.7, green: 0.5, blue: 1.0),   // Lavender purple
                Color(red: 0.5, green: 0.8, blue: 1.0)    // Baby blue
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        
        // Early School - Fresh Lime Mint
        static let earlySchoolBackground = LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.3, green: 0.9, blue: 0.6),   // Mint green
                Color(red: 0.5, green: 1.0, blue: 0.5),   // Lime green
                Color(red: 1.0, green: 0.9, blue: 0.3)    // Sunshine yellow
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        
        // Older Kids - Electric Galaxy
        static let olderKidsBackground = LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.2, green: 0.4, blue: 0.9),   // Electric blue
                Color(red: 0.6, green: 0.2, blue: 0.9),   // Purple
                Color(red: 0.9, green: 0.2, blue: 0.6)    // Magenta
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let primaryText = Color.primary
        static let secondaryText = Color.secondary
        static let accent = Color.orange
        static let success = Color.green
        static let failure = Color.red
    }
    
    struct Fonts {
        static func title(size: CGFloat = 34) -> Font {
            .system(size: size, weight: .heavy, design: .rounded)
        }
        
        static func body(size: CGFloat = 17) -> Font {
            .system(size: size, weight: .medium, design: .rounded)
        }
        
        static func gameNumber(size: CGFloat = 60) -> Font {
            .system(size: size, weight: .bold, design: .rounded)
        }
    }
}

// Helper to create colors if they don't exist in Assets
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

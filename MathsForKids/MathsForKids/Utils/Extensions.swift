import SwiftUI

// MARK: - Localization Extension
extension String {
    /// Returns a localized string from the Localizable.strings file
    var localized: String {
        return LocalizationHelper.shared.localizedString(self)
    }
    
    /// Returns a localized string with formatted arguments
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}

// MARK: - View Extensions
extension View {
    func neumorphicShadow(color: Color = .black, radius: CGFloat = 10, x: CGFloat = 5, y: CGFloat = 5) -> some View {
        self.shadow(color: color.opacity(0.2), radius: radius, x: x, y: y)
            .shadow(color: .white.opacity(0.7), radius: radius, x: -x, y: -y)
    }
    
    func bounceEffect() -> some View {
        self.scaleEffect(1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0), value: UUID())
    }
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

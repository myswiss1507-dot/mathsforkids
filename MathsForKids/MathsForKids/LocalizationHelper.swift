import SwiftUI
import Foundation
import Combine

/// Helper class for managing localization and available languages
class LocalizationHelper: ObservableObject {
    static let shared = LocalizationHelper()
    
    /// All supported languages in the app
    /// Ordered by total number of speakers (native + non-native)
    enum SupportedLanguage: String, CaseIterable, Identifiable {
        case english = "en"              // ~1.5 billion
        case chineseSimplified = "zh-Hans" // ~1.1 billion
        case hindi = "hi"                // ~600 million
        case spanish = "es"              // ~560 million
        case french = "fr"               // ~310 million
        case bengali = "bn"              // ~270 million
        case portugueseBrazil = "pt-BR"  // ~260 million
        case german = "de"               // ~135 million
        case marathi = "mr"              // ~95 million
        case telugu = "te"               // ~95 million
        case tamil = "ta"                // ~85 million
        
        var id: String { rawValue }
        
        var displayName: String {
            switch self {
            case .english: return "English"
            case .spanish: return "Español"
            case .french: return "Français"
            case .german: return "Deutsch"
            case .chineseSimplified: return "中文"
            case .portugueseBrazil: return "Português"
            case .hindi: return "हिन्दी"
            case .tamil: return "தமிழ்"
            case .telugu: return "తెలుగు"
            case .marathi: return "मराठी"
            case .bengali: return "বাংলা"
            }
        }
        
        var flag: String {
            switch self {
            case .english: return "🇺🇸"
            case .spanish: return "🇪🇸"
            case .french: return "🇫🇷"
            case .german: return "🇩🇪"
            case .chineseSimplified: return "🇨🇳"
            case .portugueseBrazil: return "🇧🇷"
            case .hindi: return "🇮🇳"
            case .tamil: return "🇮🇳"
            case .telugu: return "🇮🇳"
            case .marathi: return "🇮🇳"
            case .bengali: return "🇮🇳"
            }
        }
    }
    
    @Published var currentLanguage: SupportedLanguage {
        didSet {
            saveLanguage()
            loadTranslations()
        }
    }
    
    private var translations: [String: String] = [:]
    private let languageKey = "selectedLanguage"
    
    private init() {
        // 1. Check saved language
        if let savedLanguageCode = UserDefaults.standard.string(forKey: "selectedLanguage"),
           let savedLanguage = SupportedLanguage(rawValue: savedLanguageCode) {
            currentLanguage = savedLanguage
        } else {
            // 2. Fallback to device preferred language
            let preferredLanguage = Locale.preferredLanguages.first ?? "en"
            
            if preferredLanguage.hasPrefix("es") {
                currentLanguage = .spanish
            } else if preferredLanguage.hasPrefix("fr") {
                currentLanguage = .french
            } else if preferredLanguage.hasPrefix("de") {
                currentLanguage = .german
            } else if preferredLanguage.hasPrefix("zh") {
                currentLanguage = .chineseSimplified
            } else if preferredLanguage.hasPrefix("pt") {
                currentLanguage = .portugueseBrazil
            } else if preferredLanguage.hasPrefix("hi") {
                currentLanguage = .hindi
            } else if preferredLanguage.hasPrefix("ta") {
                currentLanguage = .tamil
            } else if preferredLanguage.hasPrefix("te") {
                currentLanguage = .telugu
            } else if preferredLanguage.hasPrefix("mr") {
                currentLanguage = .marathi
            } else if preferredLanguage.hasPrefix("bn") {
                currentLanguage = .bengali
            } else {
                currentLanguage = .english
            }
        }
        
        loadTranslations()
    }
    
    private func saveLanguage() {
        UserDefaults.standard.set(currentLanguage.rawValue, forKey: languageKey)
    }
    
    /// Get the current device language
    static var deviceLanguage: String {
        return Locale.preferredLanguages.first ?? "en"
    }
    
    /// Check if the device is using a right-to-left language
    static var isRTL: Bool {
        return Locale.characterDirection(forLanguage: deviceLanguage) == .rightToLeft
    }
    
    /// Returns the localized string for the given key
    func localizedString(_ key: String) -> String {
        return translations[key] ?? key
    }
    
    private func loadTranslations() {
        // Reset translations
        translations = [:]
        
        // 1. Try to load from standard .lproj bundle
        if let path = Bundle.main.path(forResource: currentLanguage.rawValue, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            // Load from Localizable.strings in the bundle
            if let stringsPath = bundle.path(forResource: "Localizable", ofType: "strings"),
               let dict = NSDictionary(contentsOfFile: stringsPath) as? [String: String] {
                translations = dict
                return
            }
        }
        
        // 2. Fallback: Try to load from non-standard file names (e.g., es.lprojLocalizable.strings)
        // Construct the file name based on current language
        let fileName: String
        if currentLanguage == .english {
            fileName = "Localizable"
        } else {
            fileName = "\(currentLanguage.rawValue).lprojLocalizable"
        }
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "strings"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: String] {
            translations = dict
            return
        }
        
        // 3. Fallback to English if translation not found
        if currentLanguage != .english {
            if let path = Bundle.main.path(forResource: "Localizable", ofType: "strings"),
               let dict = NSDictionary(contentsOfFile: path) as? [String: String] {
                translations = dict
            }
        }
    }
}

/// Language picker view that can be added to settings
struct LanguagePicker: View {
    @ObservedObject var localization = LocalizationHelper.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                // Gradient background
                LinearGradient(
                    colors: [
                        Color.purple.opacity(0.3),
                        Color.blue.opacity(0.2)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Header
                        VStack(spacing: 8) {
                            Text("🌍")
                                .font(.system(size: 60))
                            
                            Text("Choose Language")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Text("Select your preferred language")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        
                        // Language buttons
                        ForEach(LocalizationHelper.SupportedLanguage.allCases) { language in
                            languageButton(for: language)
                        }
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private func languageButton(for language: LocalizationHelper.SupportedLanguage) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                localization.currentLanguage = language
                // Dismiss after a short delay to show selection
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    dismiss()
                }
            }
        }) {
            HStack(spacing: 16) {
                Text(language.flag)
                    .font(.system(size: 40))
                
                Text(language.displayName)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                if localization.currentLanguage == language {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.green)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(localization.currentLanguage == language ? Color.green.opacity(0.1) : Color.white.opacity(0.7))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        localization.currentLanguage == language ? Color.green : Color.clear,
                        lineWidth: 2
                    )
            )
            .scaleEffect(localization.currentLanguage == language ? 1.02 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Preview
struct LanguagePicker_Previews: PreviewProvider {
    static var previews: some View {
        LanguagePicker()
    }
}

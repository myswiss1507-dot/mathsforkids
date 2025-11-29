# 🌍 Localization Setup Guide

## Overview
Your Math for Kids app now supports **5 languages**:
- 🇺🇸 English
- 🇪🇸 Spanish (Español)
- 🇫🇷 French (Français)
- 🇩🇪 German (Deutsch)
- 🇨🇳 Chinese Simplified (中文)

## Files Created

### 1. Localization Files
- `Localizable.strings` - English (base)
- `es.lproj/Localizable.strings` - Spanish
- `fr.lproj/Localizable.strings` - French
- `de.lproj/Localizable.strings` - German
- `zh-Hans.lproj/Localizable.strings` - Chinese Simplified

### 2. Helper Files
- `LocalizationHelper.swift` - Language management
- `Extensions.swift` - Updated with `.localized` String extension
- `Gender.swift` - Updated with `localizedName` property

### 3. Updated Views
- `ContentView.swift` - All text now uses localized strings

## How to Set Up in Xcode

### Step 1: Add Localization Files to Project
1. In Xcode, select your project in the Navigator
2. Select your target → Info tab
3. Under "Localizations", click the `+` button
4. Add: Spanish, French, German, and Chinese (Simplified)

### Step 2: Add the .strings Files
1. Right-click on your project folder
2. Select "New Group" and name it "Resources"
3. Right-click "Resources" → "Add Files to [Project]"
4. Add all the `.lproj` folders and `Localizable.strings` files
5. Make sure "Copy items if needed" is checked
6. Ensure they're added to your app target

### Step 3: Verify Localization
1. In Xcode, select `Localizable.strings` (base)
2. Open the File Inspector (right panel)
3. Under "Localization", check all your languages
4. Xcode should show all 5 language versions

### Step 4: Test Different Languages
**Method 1: Using Xcode Scheme**
1. Product → Scheme → Edit Scheme
2. Run → Options tab
3. Set "App Language" to test different languages
4. Run the app

**Method 2: On Device**
1. Settings → General → Language & Region
2. Add your preferred language
3. Run the app - it will use device language

## How to Use in Code

### Basic Usage
```swift
// Simple localization
Text("app.title".localized)

// With variables
let name = "Alex"
Text("welcome.greeting".localized(with: name))
```

### Adding New Strings
1. Add the key to **all** `Localizable.strings` files:
```
"new.key" = "English text";
```

2. Translate for each language:
- Spanish: `"new.key" = "Texto en español";`
- French: `"new.key" = "Texte en français";`
- German: `"new.key" = "Deutscher Text";`
- Chinese: `"new.key" = "中文文本";`

3. Use in code:
```swift
Text("new.key".localized)
```

## Adding More Languages

### Easy Languages to Add Next:
- 🇮🇹 Italian (it)
- 🇵🇹 Portuguese (pt-BR) - Brazilian
- 🇯🇵 Japanese (ja)
- 🇰🇷 Korean (ko)
- 🇷🇺 Russian (ru)
- 🇸🇦 Arabic (ar) - *requires RTL support*
- 🇮🇳 Hindi (hi)

### To Add a New Language:
1. Create folder: `[language-code].lproj/`
2. Copy `Localizable.strings` into it
3. Translate all strings
4. Add to Xcode project
5. Update `LocalizationHelper.SupportedLanguage` enum

## RTL (Right-to-Left) Support

For Arabic, Hebrew, etc.:
```swift
.environment(\.layoutDirection, 
    LocalizationHelper.isRTL ? .rightToLeft : .leftToRight)
```

SwiftUI automatically handles most RTL layout adjustments!

## Testing Tips

### Test Checklist:
- ✅ All text displays correctly
- ✅ No truncated text (especially German - longer words)
- ✅ Numbers format correctly (commas vs periods)
- ✅ Text fits in buttons and labels
- ✅ UI doesn't break with longer translations
- ✅ Special characters display properly (ñ, ü, 中, etc.)

### Common Issues:
1. **Missing translations**: Shows key instead of text
   - Solution: Add the key to all `.strings` files

2. **Text truncation**: Text gets cut off
   - Solution: Use `.lineLimit(nil)` or increase frame size

3. **Wrong language shows**: 
   - Solution: Check device settings and Xcode scheme

## Professional Translation Services

For production apps, consider:
- **Apple's Translation API** - Built-in iOS translation
- **Professional services**: Crowdin, Lokalise, POEditor
- **Native speakers**: Always best for quality

## Current Translation Coverage

All strings in `ContentView.swift` are localized:
- ✅ App title and tagline
- ✅ Welcome form labels
- ✅ Gender selection
- ✅ Age selection
- ✅ Button text
- ✅ Placeholders

### Still Need Translation:
You'll need to localize other views:
- `ToddlerView.swift`
- `EarlySchoolView.swift`
- `OlderKidsView.swift`
- `GameOverView.swift`
- Any other game views

## Quick Reference: String Keys

```swift
// App
"app.title"                    // Math for Kids
"app.tagline"                  // Learn • Play • Grow

// Welcome
"welcome.name.title"           // Your Name
"welcome.name.placeholder"     // Enter your name
"welcome.gender.title"         // I am a...
"welcome.age.title"            // My Age
"welcome.age.years"            // years
"welcome.swipe.hint"           // Swipe
"welcome.start.button"         // Start Learning!

// Gender
"gender.boy"                   // Boy
"gender.girl"                  // Girl

// Game
"game.correct"                 // Correct!
"game.wrong"                   // Try Again!
"game.score"                   // Score
```

## Best Practices

1. **Keep keys descriptive**: Use `welcome.name.title` not `t1`
2. **Group by feature**: All welcome screen keys start with `welcome.`
3. **Consistent naming**: Use same pattern across all keys
4. **Add comments**: Help translators understand context
5. **Test early**: Test with longest language (usually German)
6. **Update all files**: When adding keys, add to ALL languages

## Need Help?

The app will automatically use the device's language if available, otherwise defaults to English.

To manually test a specific language:
```bash
# Run in simulator with Spanish
xcrun simctl boot "iPhone 15"
xcrun simctl spawn booted defaults write NSGlobalDomain AppleLanguages -array "es"
```

Happy localizing! 🌍✨

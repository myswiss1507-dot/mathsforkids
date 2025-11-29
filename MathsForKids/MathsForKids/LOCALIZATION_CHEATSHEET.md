# 📝 Localization Cheat Sheet

## Quick Reference for Adding New Localized Strings

---

## 🔥 Most Common Use Cases

### 1. Simple Text
```swift
// In your view:
Text("game.title".localized)

// In all Localizable.strings files:
"game.title" = "Math Game";        // English
"game.title" = "Juego de Matemáticas";  // Spanish
"game.title" = "Jeu de Maths";     // French
```

### 2. Button Text
```swift
Button("button.play".localized) {
    startGame()
}

// Strings:
"button.play" = "Play";            // English
"button.play" = "Jugar";           // Spanish
```

### 3. Text with Variables
```swift
// In your view:
let score = 100
Text("game.score.message".localized(with: score))

// In all Localizable.strings files:
"game.score.message" = "Your score: %d";     // English
"game.score.message" = "Tu puntuación: %d";  // Spanish
```

### 4. Multiple Variables
```swift
let name = "Alex"
let points = 50
Text("game.greeting".localized(with: name, points))

// Strings:
"game.greeting" = "Hi %@! You have %d points";          // English
"game.greeting" = "¡Hola %@! Tienes %d puntos";        // Spanish
```

---

## 📋 Step-by-Step: Adding a New String

### Step 1: Choose a Good Key Name
Use descriptive, hierarchical keys:
```
✅ Good:
"settings.sound.title"
"game.level.easy"
"profile.edit.button"

❌ Bad:
"title"
"button1"
"text"
```

### Step 2: Add to English (base)
Open `Localizable.strings`:
```
"settings.sound.title" = "Sound Effects";
```

### Step 3: Add to All Other Languages
**Spanish** (`es.lproj/Localizable.strings`):
```
"settings.sound.title" = "Efectos de Sonido";
```

**French** (`fr.lproj/Localizable.strings`):
```
"settings.sound.title" = "Effets Sonores";
```

**German** (`de.lproj/Localizable.strings`):
```
"settings.sound.title" = "Soundeffekte";
```

**Chinese** (`zh-Hans.lproj/Localizable.strings`):
```
"settings.sound.title" = "音效";
```

**Portuguese** (`pt-BR.lproj/Localizable.strings`):
```
"settings.sound.title" = "Efeitos Sonoros";
```

### Step 4: Use in Code
```swift
Text("settings.sound.title".localized)
```

---

## 🎨 Common Patterns

### Navigation Titles
```swift
.navigationTitle("screen.settings.title".localized)
```

### Alerts
```swift
.alert("alert.error.title".localized,
       message: "alert.error.message".localized,
       dismissButton: .default(Text("button.ok".localized)))
```

### Placeholders
```swift
TextField("field.email.placeholder".localized, text: $email)
```

### Action Sheets
```swift
.actionSheet(isPresented: $showingOptions) {
    ActionSheet(
        title: Text("sheet.options.title".localized),
        buttons: [
            .default(Text("button.edit".localized)),
            .destructive(Text("button.delete".localized)),
            .cancel()
        ]
    )
}
```

---

## 🔤 String Format Specifiers

Use these in your localized strings:

| Specifier | Type | Example |
|-----------|------|---------|
| `%@` | String | "Hello %@" |
| `%d` | Integer | "Score: %d" |
| `%f` | Float | "Price: %.2f" |
| `%ld` | Long | "Count: %ld" |
| `%%` | Percent | "Success: %d%%" |

### Multiple of Same Type
Use position:
```
// English (natural order)
"message.transfer" = "Send %@ to %@";

// Japanese (reversed order)
"message.transfer" = "%2$@に%1$@を送信";
```

---

## 📂 Organization Tips

### Group by Feature
```
// User Profile
"profile.title"
"profile.edit.button"
"profile.save.button"

// Game
"game.start"
"game.pause"
"game.over"

// Settings
"settings.title"
"settings.sound"
"settings.language"
```

### Keep Alphabetical (within groups)
```
// Settings
"settings.about"
"settings.help"
"settings.language"
"settings.privacy"
"settings.sound"
```

---

## 🌍 Translation Quick Reference

### Common Words

| English | Spanish | French | German | Chinese | Portuguese |
|---------|---------|--------|--------|---------|------------|
| Hello | Hola | Bonjour | Hallo | 你好 | Olá |
| Yes | Sí | Oui | Ja | 是 | Sim |
| No | No | Non | Nein | 否 | Não |
| OK | OK | OK | OK | 好 | OK |
| Cancel | Cancelar | Annuler | Abbrechen | 取消 | Cancelar |
| Save | Guardar | Enregistrer | Speichern | 保存 | Salvar |
| Delete | Eliminar | Supprimer | Löschen | 删除 | Excluir |
| Edit | Editar | Modifier | Bearbeiten | 编辑 | Editar |
| Done | Hecho | Terminé | Fertig | 完成 | Concluído |
| Back | Atrás | Retour | Zurück | 返回 | Voltar |
| Next | Siguiente | Suivant | Weiter | 下一个 | Próximo |
| Play | Jugar | Jouer | Spielen | 玩 | Jogar |
| Start | Iniciar | Commencer | Starten | 开始 | Começar |
| Stop | Detener | Arrêter | Stoppen | 停止 | Parar |
| Settings | Ajustes | Paramètres | Einstellungen | 设置 | Configurações |
| Help | Ayuda | Aide | Hilfe | 帮助 | Ajuda |
| Score | Puntuación | Score | Punktzahl | 分数 | Pontuação |
| Level | Nivel | Niveau | Level | 关卡 | Nível |
| Time | Tiempo | Temps | Zeit | 时间 | Tempo |

---

## 🎯 Best Practices Checklist

- [ ] Use descriptive key names
- [ ] Group related keys together
- [ ] Add to ALL language files
- [ ] Keep keys alphabetical (within groups)
- [ ] Use comments for context
- [ ] Test in all languages
- [ ] Check for truncation
- [ ] Verify special characters
- [ ] Consider RTL languages
- [ ] Use proper format specifiers

---

## ⚡ Quick Commands

### Find Missing Keys
Check if a key exists in all files:
```bash
grep "game.title" *.lproj/Localizable.strings
```

### Count Strings
Count how many strings are in a file:
```bash
grep -c "=" Localizable.strings
```

### Find Unused Keys
Search for keys not used in code:
```bash
# This is manual - search your .swift files
grep -r "game.old.key" *.swift
```

---

## 🧪 Testing Checklist

Before releasing:

- [ ] Test app in each language
- [ ] Check all screens
- [ ] Verify buttons work
- [ ] Check text doesn't overflow
- [ ] Test with longest language (German)
- [ ] Test with shortest language (Chinese)
- [ ] Verify special characters (ñ, ü, 中)
- [ ] Check RTL if applicable
- [ ] Test variable substitution
- [ ] Verify plurals work correctly

---

## 💾 Template for New Feature

When adding a new feature, create keys like this:

```
// Feature: User Profile
// File: Localizable.strings (All languages)

// MARK: - Profile
"profile.title" = "Profile";
"profile.edit.button" = "Edit Profile";
"profile.save.button" = "Save Changes";
"profile.cancel.button" = "Cancel";
"profile.name.label" = "Name";
"profile.name.placeholder" = "Enter your name";
"profile.email.label" = "Email";
"profile.email.placeholder" = "Enter your email";
"profile.success.message" = "Profile updated successfully!";
"profile.error.message" = "Failed to update profile";
```

Then translate each section for all languages!

---

## 📞 Need Help?

Common issues:

**Issue:** Key shows instead of text
**Fix:** Make sure key exists in that language's `.strings` file

**Issue:** Crash with `.localized(with:)`
**Fix:** Check format specifiers match (%@, %d, etc.)

**Issue:** Wrong language shows
**Fix:** Check device/simulator language settings

**Issue:** Text looks weird
**Fix:** Check file encoding (should be UTF-8)

---

## 🎉 You're Ready!

Use this cheat sheet whenever you need to add localized text.

Remember:
1. Add key to all 6 language files
2. Use descriptive names
3. Test in each language
4. Keep it organized!

Happy localizing! 🌍✨

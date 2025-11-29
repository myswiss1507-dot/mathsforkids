import SwiftUI

struct ContentView: View {
    private let soundManager = SoundManager.shared
    @State private var userName = ""
    @State private var selectedGender: Gender?
    @State private var selectedAge: Int?
    @State private var navigateToGame = false
    @State private var isAnimating = false
    @State private var showLanguagePicker = false
    @State private var showParentReport = false
    @ObservedObject private var localization = LocalizationHelper.shared
    
    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]
    
    var isFormComplete: Bool {
        !userName.isEmpty && selectedGender != nil && selectedAge != nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Dynamic background based on gender
                if let gender = selectedGender {
                    gender.backgroundColor.ignoresSafeArea()
                } else {
                    Theme.Colors.background.ignoresSafeArea()
                }
                
                // Animated floating shapes background
                ForEach(0..<6) { index in
                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: CGFloat.random(in: 100...200), height: CGFloat.random(in: 100...200))
                        .offset(
                            x: CGFloat.random(in: -150...150),
                            y: isAnimating ? CGFloat.random(in: -300...400) : CGFloat.random(in: -400...300)
                        )
                        .blur(radius: 20)
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 3...6))
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.3),
                            value: isAnimating
                        )
                }
                
                VStack(spacing: 0) {
                    combinedInputView
                }
            }
            .animation(.easeInOut(duration: 0.3), value: selectedGender)
            .onAppear {
                isAnimating = true
                soundManager.playWelcomeSound()
            }
            .onDisappear {
            }
        }
    }
    
    // MARK: - Combined Input View
    var combinedInputView: some View {
        VStack(spacing: 25) {
            headerView
            formCardView
            startButtonView
            Spacer()
        }
        .sheet(isPresented: $showLanguagePicker) {
            LanguagePicker()
        }
        .sheet(isPresented: $showParentReport) {
            ParentReportView()
        }
        .onAppear {
            // Load user data and auto-navigate if complete
            loadUserData()
            if isFormComplete {
                // Delay to allow UI to load and user to see landing page
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    navigateToGame = true
                }
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 12) {
            // Top Bar with Language and Parent Report
            HStack {
                languageButton
                Spacer()
                parentReportButton
            }
            .padding(.horizontal, 25)
            .padding(.top, 15)
            
            // App Icon/Logo
            ZStack {
                Circle()
                    .fill(headerCircleGradient)
                    .frame(width: 70, height: 70)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.6), lineWidth: 2.5)
                    )
                
                Text("🧮")
                    .font(.system(size: 35))
            }
            .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)
            
            Text("app.title".localized)
                .font(.system(size: 32, weight: .heavy, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, Color.white.opacity(0.9)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 3)
            
            Text("app.tagline".localized)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.pink.opacity(0.95), Color.purple.opacity(0.9)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .tracking(2)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
        }
        .padding(.top, 10)
    }
    
    // MARK: - Parent Report Button
    private var parentReportButton: some View {
        Button(action: {
            soundManager.playButtonTap()
            showParentReport = true
        }) {
            Image(systemName: "person.2.fill")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(10)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .background(
                            Circle()
                                .fill(.ultraThinMaterial)
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.4), lineWidth: 1)
                        )
                )
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    private var headerCircleGradient: LinearGradient {
        LinearGradient(
            colors: [Color.white.opacity(0.3), Color.white.opacity(0.1)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Name Input View
    private var nameInputView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "person.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.cyan.opacity(0.9), Color.blue.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("welcome.name.title".localized)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, Color.white.opacity(0.95)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 2)
            
            nameTextField
        }
        .padding(.horizontal, 25)
    }
    
    private var nameTextField: some View {
        TextField("welcome.name.placeholder".localized, text: $userName)
            .font(.system(size: 18, weight: .medium, design: .rounded))
            .foregroundColor(.black)
            .padding(.vertical, 12)
            .padding(.horizontal, 15)
            .background(nameTextFieldBackground)
            .overlay(nameTextFieldOverlay)
            .multilineTextAlignment(.center)
            .tint(.blue)
    }
    
    private var nameTextFieldBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.white)
            .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
    }
    
    private var nameTextFieldOverlay: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(userName.isEmpty ? Color.clear : Color.green.opacity(0.5), lineWidth: 2)
    }
    
    // MARK: - Gender Selection View
    private var genderSelectionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "figure.2")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.pink.opacity(0.9), Color.purple.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("welcome.gender.title".localized)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, Color.white.opacity(0.95)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .padding(.horizontal, 25)
            .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 2)
            
            HStack(spacing: 15) {
                ForEach(Gender.allCases, id: \.self) { gender in
                    genderButton(for: gender)
                }
                Spacer()
            }
            .padding(.horizontal, 25)
        }
    }
    
    private func genderButton(for gender: Gender) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                soundManager.playButtonTap()
                selectedGender = gender
            }
        }) {
            VStack(spacing: 8) {
                Text(gender.emoji)
                    .font(.system(size: 40))
                
                Text(gender.localizedName)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
            }
            .frame(width: 110, height: 100)
            .background(genderButtonBackground(for: gender))
            .overlay(genderButtonOverlay(for: gender))
            .scaleEffect(selectedGender == gender ? 1.05 : 1.0)
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    private func genderButtonBackground(for gender: Gender) -> some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(selectedGender == gender ? gender.primaryColor : Color.white.opacity(0.25))
            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
    
    private func genderButtonOverlay(for gender: Gender) -> some View {
        RoundedRectangle(cornerRadius: 18)
            .stroke(Color.white, lineWidth: selectedGender == gender ? 3 : 0)
    }
    
    // MARK: - Age Selection View
    private var ageSelectionView: some View {
        VStack(alignment: .leading, spacing: 4) {
            ageSelectionHeader
            ageScrollView
        }
    }
    
    private var ageSelectionHeader: some View {
        HStack(spacing: 6) {
            Image(systemName: "birthday.cake.fill")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.yellow.opacity(0.95), Color.orange.opacity(0.85)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("welcome.age.title".localized)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, Color.white.opacity(0.95)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            Spacer()
            
            // Subtle swipe indicator
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 12, weight: .semibold))
                Text("welcome.swipe.hint".localized)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundStyle(
                LinearGradient(
                    colors: [Color.white.opacity(0.75), Color.white.opacity(0.6)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
        }
        .padding(.horizontal, 25)
        .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 2)
    }
    
    private var ageScrollView: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(2...12, id: \.self) { age in
                        ageButton(for: age)
                    }
                }
                .padding(.horizontal, 25)
                .padding(.vertical, 8)
            }
            
            ageScrollGradients
        }
    }
    
    private func ageButton(for age: Int) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                soundManager.playButtonTap()
                selectedAge = age
            }
        }) {
            VStack(spacing: 4) {
                Text("\(age)")
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                
                Text("welcome.age.years".localized)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
            }
            .frame(width: 75, height: 80)
            .background(ageButtonBackground(for: age))
            .overlay(ageButtonOverlay(for: age))
            .scaleEffect(selectedAge == age ? 1.12 : 1.0)
            .rotation3DEffect(
                .degrees(selectedAge == age ? 0 : 5),
                axis: (x: 0, y: 1, z: 0)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func ageButtonBackground(for age: Int) -> some View {
        ZStack {
            let isSelected = selectedAge == age
            let fillColor = isSelected ? ageColor(for: age) : Color.white.opacity(0.2)
            
            RoundedRectangle(cornerRadius: 18)
                .fill(fillColor)
            
            if isSelected {
                RoundedRectangle(cornerRadius: 18)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.3), Color.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        }
        .shadow(
            color: selectedAge == age ? Color.black.opacity(0.3) : Color.black.opacity(0.15),
            radius: selectedAge == age ? 10 : 5,
            x: 0,
            y: selectedAge == age ? 5 : 2
        )
    }
    
    private func ageButtonOverlay(for age: Int) -> some View {
        RoundedRectangle(cornerRadius: 18)
            .stroke(
                selectedAge == age ? Color.white : Color.white.opacity(0.2),
                lineWidth: selectedAge == age ? 3 : 1
            )
    }
    
    private var ageScrollGradients: some View {
        HStack {
            LinearGradient(
                colors: [Color.white.opacity(0.3), Color.clear],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: 30)
            .allowsHitTesting(false)
            
            Spacer()
            
            LinearGradient(
                colors: [Color.clear, Color.white.opacity(0.3)],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: 30)
            .allowsHitTesting(false)
        }
    }
    
    // MARK: - Form Card View
    private var formCardView: some View {
        VStack(spacing: 25) {
            nameInputView
            genderSelectionView
            ageSelectionView
        }
        .padding(.vertical, 20)
        .background(formCardBackground)
        .padding(.horizontal, 20)
    }
    
    private var formCardBackground: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(Color.white.opacity(0.15))
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
            )
    }
    
    // MARK: - Persistence
    private func saveUserData() {
        UserDefaults.standard.set(userName, forKey: "userName")
        if let gender = selectedGender {
            UserDefaults.standard.set(gender.rawValue, forKey: "selectedGender")
        }
        if let age = selectedAge {
            UserDefaults.standard.set(age, forKey: "selectedAge")
        }
    }
    
    private func loadUserData() {
        if let savedName = UserDefaults.standard.string(forKey: "userName"), !savedName.isEmpty {
            userName = savedName
        }
        
        if let savedGenderRaw = UserDefaults.standard.string(forKey: "selectedGender"),
           let gender = Gender(rawValue: savedGenderRaw) {
            selectedGender = gender
        }
        
        if let savedAge = UserDefaults.standard.object(forKey: "selectedAge") as? Int {
            selectedAge = savedAge
        }
    }
    
    // MARK: - Start Button View
    private var startButtonView: some View {
        Group {
            if let age = selectedAge {
                // Manual navigation link
                NavigationLink(destination: destinationView(for: age), isActive: $navigateToGame) {
                    EmptyView()
                }
                
                Button(action: {
                    saveUserData()
                    soundManager.playButtonTap()
                    navigateToGame = true
                }) {
                    startButtonContent
                }
                .disabled(!isFormComplete)
                .padding(.top, 5)
                .padding(.bottom, 20)
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    private var startButtonContent: some View {
        HStack(spacing: 10) {
            Image(systemName: "play.circle.fill")
                .font(.system(size: 24))
            
            Text("welcome.start.button".localized)
                .font(.system(size: 22, weight: .bold, design: .rounded))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 45)
        .padding(.vertical, 16)
        .background(startButtonBackground)
        .overlay(startButtonOverlay)
        .scaleEffect(isFormComplete ? 1.0 : 0.95)
    }
    
    private var startButtonBackground: some View {
        Group {
            if isFormComplete {
                RoundedRectangle(cornerRadius: 20)
                .fill(startButtonGradient)
                .shadow(color: Color.green.opacity(0.5), radius: 15, x: 0, y: 8)
            } else {
                RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.5))
            }
        }
    }
    
    private var startButtonGradient: LinearGradient {
        LinearGradient(
            colors: [Color(red: 0.2, green: 0.8, blue: 0.4), Color(red: 0.1, green: 0.6, blue: 0.3)],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private var startButtonOverlay: some View {
        RoundedRectangle(cornerRadius: 20)
        .stroke(Color.white.opacity(0.3), lineWidth: 2)
    }
    

    
    // MARK: - Language Button
    private var languageButton: some View {
        Button(action: {
            soundManager.playButtonTap()
            showLanguagePicker = true
        }) {
            HStack(spacing: 8) {
                Text(localization.currentLanguage.flag)
                    .font(.system(size: 20))
                
                Text(localization.currentLanguage.displayName)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.4), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    @ViewBuilder
    func destinationView(for age: Int) -> some View {
        if age <= 4 {
            ToddlerView()
        } else if age <= 7 {
            EarlySchoolView()
        } else {
            OlderKidsView()
        }
    }
    
    func ageColor(for age: Int) -> Color {
        if age <= 4 {
            return .orange
        } else if age <= 7 {
            return .green
        } else {
            return .blue
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

import SwiftUI

struct GameExitButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            // Play sound?
            SoundManager.shared.playButtonTap()
            action()
        }) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 32))
                .foregroundColor(.red)
                .background(
                    Circle()
                        .fill(Color.white)
                        .padding(2)
                )
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct GameExitButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue
            GameExitButton(action: {})
        }
    }
}

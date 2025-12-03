import SwiftUI

struct ImplicitExplicitAnimations: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        VStack(spacing: 40) {
            // Implicit - animation attachée à la View
            Circle()
                .fill(.blue)
                .frame(width: 100, height: 100)
                .scaleEffect(scale)
                .animation(.spring(), value: scale)

            Text("Implicit Animation")
                .font(.caption)

            // Explicit - animation dans l'action
            Button("Animate") {
                withAnimation(.spring()) {
                    scale = scale == 1.0 ? 1.5 : 1.0
                }
            }
        }
    }
}

#Preview {
    ImplicitExplicitAnimations()
}

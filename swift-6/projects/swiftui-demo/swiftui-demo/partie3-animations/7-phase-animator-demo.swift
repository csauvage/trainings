import SwiftUI

struct PhaseAnimatorDemo: View {
    var body: some View {
        PhaseAnimator([false, true]) { phase in
            Circle()
                .fill(.blue)
                .frame(width: 100, height: 100)
                .scaleEffect(phase ? 1.5 : 1.0)
                .opacity(phase ? 0.5 : 1.0)
        } animation: { phase in
            .easeInOut(duration: 1.0)
        }
    }
}

#Preview {
    PhaseAnimatorDemo()
}

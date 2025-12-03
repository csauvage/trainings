import SwiftUI

struct AnimationCurves: View {
    @State private var offset: CGFloat = 0

    var body: some View {
        VStack(spacing: 30) {
            Circle()
                .fill(.blue)
                .frame(width: 50, height: 50)
                .offset(x: offset)

            VStack(spacing: 15) {
                Button("Linear") {
                    withAnimation(.linear(duration: 1.0)) {
                        offset = offset == 0 ? 100 : 0
                    }
                }

                Button("Ease In/Out") {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        offset = offset == 0 ? 100 : 0
                    }
                }

                Button("Spring") {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                        offset = offset == 0 ? 100 : 0
                    }
                }

                Button("Smooth (iOS 17+)") {
                    withAnimation(.smooth(duration: 0.5)) {
                        offset = offset == 0 ? 100 : 0
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    AnimationCurves()
}

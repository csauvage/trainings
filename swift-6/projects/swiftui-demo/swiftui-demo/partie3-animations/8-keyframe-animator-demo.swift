import SwiftUI

struct AnimationValues {
    var scale = 1.0
    var rotation = Angle.zero
}

struct KeyframeAnimatorDemo: View {
    @State private var trigger = false

    var body: some View {
        VStack(spacing: 30) {
            Circle()
                .fill(.blue)
                .frame(width: 100, height: 100)
                .keyframeAnimator(
                    initialValue: AnimationValues(),
                    trigger: trigger
                ) { content, value in
                    content
                        .scaleEffect(value.scale)
                        .rotationEffect(value.rotation)
                } keyframes: { _ in
                    KeyframeTrack(\.scale) {
                        SpringKeyframe(1.5, duration: 0.3)
                        SpringKeyframe(1.0, duration: 0.3)
                    }
                    KeyframeTrack(\.rotation) {
                        LinearKeyframe(.degrees(45), duration: 0.3)
                        LinearKeyframe(.degrees(0), duration: 0.3)
                    }
                }

            Button("Animate") {
                trigger.toggle()
            }
        }
    }
}

#Preview {
    KeyframeAnimatorDemo()
}

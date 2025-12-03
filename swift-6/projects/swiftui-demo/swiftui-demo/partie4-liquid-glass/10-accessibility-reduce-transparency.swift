import SwiftUI

struct AccessibilityReduceTransparency: View {
    @Environment(\.accessibilityReduceTransparency)
    var reduceTransparency

    var body: some View {
        VStack(spacing: 30) {
            Text("Accessibility Adaptation")
                .font(.title)

            Text("Reduce Transparency: \(reduceTransparency ? "ON" : "OFF")")
                .font(.headline)

            if reduceTransparency {
                // Alternative UI without transparency
                VStack {
                    Text("Content with Solid Background")
                        .padding()
                }
                .frame(maxWidth: .infinity, minHeight: 120)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                Text("Solid background used when transparency is reduced")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            } else {
                // Glass effect UI (Liquid Glass on iOS 26+, blur fallback otherwise)
                ZStack {
                    GlassCard()
                    Text("Content with Liquid Glass")
                        .padding()
                }
                .frame(maxWidth: .infinity, minHeight: 120)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                Text("Liquid Glass shown normally (respects Reduce Transparency in Settings)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            Text("Go to Settings > Accessibility > Display & Text Size > Reduce Transparency to test")
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}

private struct GlassCard: View {
    var body: some View {
        Group {
            // Use the UIKit-backed glass effect when available; the representable
            // gracefully falls back to a standard blur on earlier iOS versions.
            GlassEffectViewRepresentable(
                variant: .regular,
                interactive: true,
                // Omit tint to use the default system blue defined in the representable.
                animated: true
            )
        }
    }
}

#Preview {
    AccessibilityReduceTransparency()
}

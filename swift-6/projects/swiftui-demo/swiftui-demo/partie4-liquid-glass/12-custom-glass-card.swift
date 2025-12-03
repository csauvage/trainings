import SwiftUI
import UIKit

struct CustomGlassCard<Content: View>: View {
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    // Customization
    let tint: Color?
    let variant: GlassEffectViewRepresentable.Variant
    let interactive: Bool
    let cornerRadius: CGFloat
    let showsBorder: Bool
    @ViewBuilder let content: Content

    init(
        tint: Color? = nil, // nil = neutral card (no color cast)
        variant: GlassEffectViewRepresentable.Variant = .regular,
        interactive: Bool = true,
        cornerRadius: CGFloat = 20,
        showsBorder: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.tint = tint
        self.variant = variant
        self.interactive = interactive
        self.cornerRadius = cornerRadius
        self.showsBorder = showsBorder
        self.content = content()
    }

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        ZStack {
            backgroundView
                .clipShape(shape)
                .overlay(borderOverlay(shape: shape))
                .shadow(color: .black.opacity(0.1), radius: 10, y: 5)

            content
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        if reduceTransparency {
            // Solid fallback when user reduces transparency
            Color(.secondarySystemBackground)
        } else {
            if #available(iOS 26.0, *) {
                // Liquid Glass (UIKit-backed)
                GlassEffectViewRepresentable(
                    variant: variant,
                    interactive: interactive,
                    // Default to a neutral glass if no tint is provided
                    tint: tint.map { UIColor($0) } ?? .clear,
                    animated: true
                )
            } else {
                // Pre‑iOS 26 fallback: system material
                Color.clear
                    .background(.ultraThinMaterial)
            }
        }
    }

    @ViewBuilder
    private func borderOverlay(shape: some InsettableShape) -> some View {
        if showsBorder {
            shape
                .strokeBorder(
                    .linearGradient(
                        colors: [
                            Color.white.opacity(reduceTransparency ? 0.15 : 0.35),
                            Color.white.opacity(0.06)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        } else {
            EmptyView()
        }
    }
}

struct CustomGlassCardDemo: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Custom Glass Card Component")
                    .font(.title)

                // Neutral glass (no tint)
                CustomGlassCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Profile Card")
                            .font(.headline)
                        Text("This is a custom glass card component")
                            .font(.body)
                        Text("It can contain any SwiftUI content")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                // Tinted glass (e.g., subtle blue cast)
                CustomGlassCard(tint: .blue) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Settings")
                            .font(.headline)
                        Toggle("Notifications", isOn: .constant(true))
                        Toggle("Dark Mode", isOn: .constant(false))
                    }
                }

                // Prominent visual card with icon
                CustomGlassCard(tint: .yellow, cornerRadius: 24) {
                    VStack(spacing: 15) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.yellow)
                        Text("Featured Content")
                            .font(.headline)
                        Text("A reusable card leveraging Liquid Glass on iOS 26+")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    CustomGlassCardDemo()
}

import SwiftUI
import UIKit

struct UIKitGlassEffectDemo: View {
    @State private var variant: GlassEffectViewRepresentable.Variant = .regular
    @State private var isInteractive = true
    @State private var useBlueTint = true

    var body: some View {
        VStack(spacing: 20) {
            Text("UIKit Glass Effect")
                .font(.title)

            if #available(iOS 26.0, *) {
                Text("UIGlassEffect (iOS 26+)")
                    .font(.headline)

                // Controls to illustrate configuration
                Picker("Variant", selection: $variant) {
                    Text("Regular").tag(GlassEffectViewRepresentable.Variant.regular)
                    Text("Clear").tag(GlassEffectViewRepresentable.Variant.clear)
                }
                .pickerStyle(.segmented)

                Toggle("Interactive", isOn: $isInteractive)
                    .toggleStyle(.switch)

                Toggle("Blue Tint", isOn: $useBlueTint)
                    .toggleStyle(.switch)

                GlassEffectViewRepresentable(
                    variant: variant,
                    interactive: isInteractive,
                    tint: useBlueTint ? .systemBlue : nil,
                    animated: true
                )
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                Text("Fallback (pre‑iOS 26)")
                    .font(.headline)

                GlassEffectViewRepresentable() // falls back to UIBlurEffect
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // Code sample for reference
            VStack(alignment: .leading, spacing: 10) {
                Text("Code Example:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                if #available(iOS 26.0, *) {
                    Text("""
                    let effectView = UIVisualEffectView()
                    let glassEffect = UIGlassEffect()
                    glassEffect.isInteractive = true
                    glassEffect.tintColor = .systemBlue
                    UIView.animate(withDuration: 0.3) {
                        effectView.effect = glassEffect
                    }

                    // Variants
                    let regularGlass = UIGlassEffect()
                    let clearGlass: UIVisualEffect = {
                        let g = UIGlassEffect()
                        g.tintColor = .clear
                        return g
                    }()
                    """)
                    .font(.system(.caption, design: .monospaced))
                } else {
                    Text("""
                    // Fallback: regular blur on older iOS
                    let blurEffect = UIBlurEffect(style: .systemMaterial)
                    let effectView = UIVisualEffectView(effect: blurEffect)
                    """)
                    .font(.system(.caption, design: .monospaced))
                }
            }
            .padding()
            .background(Color.gray.opacity(0.08))
            .cornerRadius(10)
        }
        .padding()
    }
}

struct GlassEffectViewRepresentable: UIViewRepresentable {
    enum Variant {
        case regular
        case clear
    }

    var variant: Variant = .regular
    var interactive: Bool = true
    var tint: UIColor? = .systemBlue
    var animated: Bool = true

    func makeUIView(context: Context) -> UIVisualEffectView {
        let effectView = UIVisualEffectView()
        effectView.clipsToBounds = true
        applyEffect(to: effectView, animated: false)
        return effectView
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        applyEffect(to: uiView, animated: animated)
    }

    private func applyEffect(to effectView: UIVisualEffectView, animated: Bool) {
        if #available(iOS 26.0, *) {
            let targetEffect: UIVisualEffect? = {
                switch variant {
                case .regular:
                    let glass = UIGlassEffect()
                    glass.isInteractive = interactive
                    glass.tintColor = tint
                    return glass
                case .clear:
                    // Clear variant ignores external tint, uses a transparent tint to remove coloration
                    let glass = UIGlassEffect()
                    glass.isInteractive = interactive
                    glass.tintColor = .clear
                    return glass
                }
            }()

            if animated {
                UIView.animate(withDuration: 0.3) {
                    effectView.effect = targetEffect
                }
            } else {
                effectView.effect = targetEffect
            }
        } else {
            // Fallback on older iOS with a standard blur
            effectView.effect = UIBlurEffect(style: .systemMaterial)
        }
    }
}

#Preview {
    UIKitGlassEffectDemo()
}

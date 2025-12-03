import SwiftUI

struct GlassEffectContainerDemo: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            ZStack {
                // Subtle gradient so glass is visible without being too strong
                LinearGradient(
                    colors: [
                        Color(hue: 0.60, saturation: 0.16, brightness: 0.96),
                        Color(hue: 0.56, saturation: 0.12, brightness: 0.92),
                        Color(hue: 0.53, saturation: 0.10, brightness: 0.90)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 28) {
                    Text("Glass Effect Container")
                        .font(.title.bold())

                    // GlassEffectContainer usage
                    GlassEffectContainer(spacing: 40) {
                        HStack(spacing: 40) {
                            Image(systemName: "pencil")
                                .font(.system(size: 40, weight: .regular, design: .default))
                                .frame(width: 80, height: 80)
                                .glassEffect()

                            Image(systemName: "eraser")
                                .font(.system(size: 40, weight: .regular, design: .default))
                                .frame(width: 80, height: 80)
                                .glassEffect()

                            Image(systemName: "paintbrush")
                                .font(.system(size: 40, weight: .regular, design: .default))
                                .frame(width: 80, height: 80)
                                .glassEffect()
                        }
                    }

                    // Variants: demonstrate spacing + tint + shapes
                    GlassEffectContainer(spacing: 20) {
                        HStack(spacing: 20) {
                            Text("Capsule")
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .glassEffect(.regular, in: .capsule)

                            Text("Rounded")
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .glassEffect(.regular, in: .rect(cornerRadius: 16))

                            Text("Tinted")
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .glassEffect(.regular.tint(.blue))
                        }
                    }
                }
                .padding(24)
            }
        } else {
            // Fallback for earlier iOS versions
            VStack(spacing: 24) {
                Text("Glass Effect Container")
                    .font(.title)

                Text("Requires iOS 26 for GlassEffectContainer.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                HStack(spacing: 40) {
                    Image(systemName: "pencil")
                        .font(.system(size: 40))
                        .frame(width: 80, height: 80)
                        .background(Color.black.opacity(0.08))
                        .cornerRadius(10)

                    Image(systemName: "eraser")
                        .font(.system(size: 40))
                        .frame(width: 80, height: 80)
                        .background(Color.black.opacity(0.08))
                        .cornerRadius(10)

                    Image(systemName: "paintbrush")
                        .font(.system(size: 40))
                        .frame(width: 80, height: 80)
                        .background(Color.black.opacity(0.08))
                        .cornerRadius(10)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [.black.opacity(0.05), .black.opacity(0.12)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
        }
    }
}

#Preview {
    GlassEffectContainerDemo()
}

import SwiftUI

struct GlassEffectModifier: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            ZStack {
                // Simple, subtle gradient background
                LinearGradient(
                    colors: [
                        Color(hue: 0.60, saturation: 0.16, brightness: 0.96), // soft bluish
                        Color(hue: 0.56, saturation: 0.12, brightness: 0.92), // minty blue
                        Color(hue: 0.53, saturation: 0.10, brightness: 0.90)  // gentle teal
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        Text("Liquid Glass Effects")
                            .font(.title.bold())
                            .padding(.top, 8)

                        // Basic
                        Text("Hello, Glass!")
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .glassEffect()

                        // Variants
                        VStack(spacing: 12) {
                            Text("Regular")
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .glassEffect(.regular)

                            Text("Clear")
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .glassEffect(.clear)
                        }

                        // With shape
                        VStack(spacing: 12) {
                            Text("Regular in Capsule")
                                .padding(.horizontal, 20)
                                .padding(.vertical, 14)
                                .glassEffect(.regular, in: .capsule)

                            Text("Regular in Rounded Rect (20)")
                                .padding(.horizontal, 20)
                                .padding(.vertical, 14)
                                .glassEffect(.regular, in: .rect(cornerRadius: 20))
                        }

                        // With tint
                        VStack(spacing: 12) {
                            Text("Regular + Tint(.blue)")
                                .padding(.horizontal, 20)
                                .padding(.vertical, 14)
                                .glassEffect(.regular.tint(.blue))

                            Text("Regular + Tint(.pink)")
                                .padding(.horizontal, 20)
                                .padding(.vertical, 14)
                                .glassEffect(.regular.tint(.pink))
                        }

                        // Interactive
                        VStack(spacing: 12) {
                            Text("Regular + Tint(.blue) + Interactive")
                                .padding(.horizontal, 20)
                                .padding(.vertical, 14)
                                .glassEffect(.regular.tint(.blue).interactive())

                            Text("Clear + Interactive")
                                .padding(.horizontal, 20)
                                .padding(.vertical, 14)
                                .glassEffect(.clear.interactive())
                        }
                    }
                    .padding(20)
                }
            }
        } else {
            // Fallback for earlier iOS (kept minimal for previews or older runtimes)
            VStack(spacing: 30) {
                Text("Liquid Glass Effects (Fallback)")
                    .font(.title)
                    .padding()

                Text("This device doesn't support iOS 26 glassEffect API.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(colors: [.black.opacity(0.05), .black.opacity(0.12)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()
            )
        }
    }
}

#Preview {
    GlassEffectModifier()
}

import SwiftUI

struct GlassMorphingDemo: View {
    @State private var showDetail = false
    @Namespace private var namespace

    var body: some View {
        if #available(iOS 26.0, *) {
            ZStack {
                Color.clear.ignoresSafeArea()

                if !showDetail {
                    Button("Show More") {
                        withAnimation(.smooth) {
                            showDetail = true
                        }
                    }
                    .padding(20)
                    .glassEffect()
                    .glassEffectID("button", in: namespace)
                } else {
                    VStack(spacing: 12) {
                        Text("Details")
                            .font(.headline)
                        Button("Hide") {
                            withAnimation(.smooth) {
                                showDetail = false
                            }
                        }
                    }
                    .padding(24)
                    .glassEffect()
                    .glassEffectID("button", in: namespace)
                }
            }
        } else {
            VStack(spacing: 12) {
                Text("Glass Morphing (Fallback)")
                    .font(.title2.bold())
                Text("Requires iOS 26 for .glassEffect / .glassEffectID.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.08))
                    .frame(height: 120)
                    .overlay(Text("No glass morphing available").font(.caption))
                    .padding(.horizontal)
            }
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
    GlassMorphingDemo()
}

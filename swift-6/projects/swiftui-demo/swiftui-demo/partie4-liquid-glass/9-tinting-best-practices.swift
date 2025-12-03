import SwiftUI

struct TintingBestPractices: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                Text("Tinting Best Practices")
                    .font(.title)

                // ✅ BON - Tint avec signification
                VStack(spacing: 16) {
                    Text("✅ BON - Tint avec signification")
                        .font(.headline)
                        .foregroundColor(.green)

                    Group {
                        if #available(iOS 26.0, *) {
                            Button("Checkout") {
                                // checkout action
                            }
                            .buttonStyle(.glassProminent)
                            .tint(.red) // Rouge = attention, action importante
                        } else {
                            Button("Checkout") {
                                // checkout action
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red) // Fallback style pre‑iOS 26
                        }
                    }

                    Text("Rouge = attention, action importante")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Divider()

                // ❌ MAUVAIS - Tint décoratif partout
                VStack(spacing: 16) {
                    Text("❌ MAUVAIS - Tint décoratif partout")
                        .font(.headline)
                        .foregroundColor(.red)

                    VStack(spacing: 10) {
                        Button("Action 1") { }
                            .buttonStyle(.glass)
                            .tint(.blue)
                        Button("Action 2") { }
                            .buttonStyle(.glass)
                            .tint(.green)
                        Button("Action 3") { }
                            .buttonStyle(.glass)
                            .tint(.purple)
                        Button("Action 4") { }
                            .buttonStyle(.glass)
                            .tint(.orange)
                    }

                    Text("Trop de couleurs sans signification")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Divider()

                // Règles de Tinting
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tinting rules")
                        .font(.headline)

                    Text("• Avec signification, pas décoration")
                    Text("• Un ou deux tints max par écran")
                    Text("• Tints s'adaptent au background (light/dark)")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}

#Preview {
    TintingBestPractices()
}

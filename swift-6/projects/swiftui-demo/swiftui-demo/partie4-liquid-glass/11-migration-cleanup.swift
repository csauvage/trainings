import SwiftUI

// This file demonstrates obsolete modifiers that should be removed when migrating to iOS 26+
struct MigrationCleanup: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    Text("Migration: Automatic Adoption")
                        .font(.title)

                    VStack(alignment: .leading, spacing: 15) {
                        Text("Obsolete Modifiers to Remove:")
                            .font(.headline)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("❌ .toolbarBackground(.visible, for: .navigationBar)")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.red)

                            Text("❌ .presentationBackground(.ultraThinMaterial)")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.red)

                            Text("❌ .background(.regularMaterial)")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.red)
                        }
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(10)

                        Text("✅ In iOS 26+, glass effects are applied automatically")
                            .font(.subheadline)
                            .foregroundColor(.green)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(10)
                    }

                    Text("Simply remove these modifiers and the system will handle the glass effect automatically")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            .navigationTitle("Migration")
        }
    }
}

#Preview {
    MigrationCleanup()
}

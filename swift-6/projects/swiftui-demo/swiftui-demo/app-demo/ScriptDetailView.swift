import SwiftUI

struct ScriptDetailView: View {
    let script: DemoScript

    var body: some View {
        if #available(iOS 26.0, *) {
            // iOS 26+ — vivid background and floating glass sections
            ZStack {
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

                ScrollView {
                    VStack(spacing: 16) {
                        // Header card
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("#\(script.number)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.accentColor)
                                    .cornerRadius(6)
                                Spacer()
                            }

                            Text(script.title)
                                .font(.title2.bold())

                            Text(script.description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(16)
                        .glassEffect(.regular, in: .rect(cornerRadius: 18))
                        .padding(.horizontal)

                        // Demo content container
                        VStack(spacing: 0) {
                            script.view
                                .frame(maxWidth: .infinity, minHeight: 320)
                                .padding()
                        }
                        .glassEffect(.regular, in: .rect(cornerRadius: 18))
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        } else {
            // Fallback — your original layout
            VStack(spacing: 0) {
                // Header with info
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("#\(script.number)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.accentColor)
                            .cornerRadius(6)

                    }
                    
                    Text(script.title)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(script.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .systemGroupedBackground))

                Divider()

                // Demo content
                ScrollView {
                    script.view
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        ScriptDetailView(
            script: DemoScript(
                number: 1,
                title: "View Identity & Lifecycle",
                description: "Understanding view identity with .id() modifier",
                view: ViewIdentityLifecycle()
            )
        )
    }
}

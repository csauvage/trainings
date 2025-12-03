import SwiftUI

struct DemoListView: View {
    let parties = DemoData.shared.parties

    var body: some View {
        if #available(iOS 26.0, *) {
            // iOS 26+:
            // - Sidebar floats above content with a glass appearance.
            // - .backgroundExtensionEffect() extends the detail background under the sidebar.
            // - Mirrored/blurred content outside the safe area is more visible on iPad.
            //   We gently dim the top/bottom edges to reduce the perceived intensity.
            NavigationSplitView {
                // Sidebar
                List {
                    ForEach(parties) { partie in
                        Section {
                            ForEach(partie.scripts) { script in
                                NavigationLink {
                                    // Destination is shown in the detail column
                                    ScriptDetailView(script: script)
                                } label: {
                                    ScriptRowView(script: script)
                                }
                            }
                        } header: {
                            PartieHeaderView(partie: partie)
                        }
                    }
                }
                .navigationTitle("SwiftUI Demos")
                .backgroundExtensionEffect()
            } detail: {
                // Vivid background so the glass sidebar effect is obvious
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

                    VStack(spacing: 12) {
                        Image(systemName: "hand.tap")
                            .font(.system(size: 40, weight: .semibold))
                            .foregroundStyle(.secondary)
                        Text("Select a demo")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                }
                // Dim the top & bottom edges to soften the mirrored reflection outside safe areas.
                .overlay(alignment: .top) {
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.12),
                            Color.black.opacity(0.06),
                            .clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 80)
                    .ignoresSafeArea(edges: .top)
                    .allowsHitTesting(false)
                }
                .overlay(alignment: .bottom) {
                    LinearGradient(
                        colors: [
                            .clear,
                            Color.black.opacity(0.06),
                            Color.black.opacity(0.12)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 100)
                    .ignoresSafeArea(edges: .bottom)
                    .allowsHitTesting(false)
                }
            }
        } else {
            // Fallback: your original List-based UI
            NavigationStack {
                List {
                    ForEach(parties) { partie in
                        Section {
                            ForEach(partie.scripts) { script in
                                NavigationLink {
                                    ScriptDetailView(script: script)
                                } label: {
                                    ScriptRowView(script: script)
                                }
                            }
                        } header: {
                            PartieHeaderView(partie: partie)
                        }
                    }
                }
                .navigationTitle("SwiftUI Demos")
                .navigationBarTitleDisplayMode(.large)
            }
        }
    }
}

struct PartieHeaderView: View {
    let partie: Partie

    var body: some View {
        HStack {
            Text("Partie \(partie.number)")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(partieColor)
                .cornerRadius(8)

            Text(partie.title)
                .font(.headline)
        }
        .padding(.vertical, 4)
    }

    private var partieColor: Color {
        switch partie.number {
        case 1: return .blue
        case 2: return .green
        case 3: return .purple
        case 4: return .orange
        default: return .gray
        }
    }
}

struct ScriptRowView: View {
    let script: DemoScript

    var body: some View {
        HStack(spacing: 12) {
            // Number badge
            Text("\(script.number)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(Color.accentColor)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(script.title)
                    .font(.body)
                    .fontWeight(.medium)

                Text(script.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    DemoListView()
}

import SwiftUI

struct SectionHeader: View {
    let title: String
    let subtitle: String?

    init(_ title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)

            if let subtitle, !subtitle.isEmpty {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ModelStatusRow: View {
    let modelAvailable: Bool
    var refreshAction: (() -> Void)?

    var body: some View {
        HStack {
            Image(systemName: modelAvailable ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                .foregroundStyle(modelAvailable ? .green : .orange)

            Text(modelAvailable ? "Language Model Available" : "Language Model Unavailable")
                .font(.subheadline)

            if let refreshAction {
                Spacer()
                Button(action: refreshAction) {
                    Image(systemName: "arrow.clockwise")
                }
                .buttonStyle(.bordered)
                .accessibilityLabel("Refresh model availability")
            }
        }
        .padding(.vertical, 8)
    }
}

struct ErrorBanner: View {
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.orange)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }
}

struct InfoBox<Content: View>: View {
    let iconName: String
    let tint: Color
    let title: String
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: iconName)
                    .foregroundStyle(tint)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }

            content()
        }
        .padding()
        .background(tint.opacity(0.1))
        .cornerRadius(12)
    }
}

struct CodeExampleBox: View {
    let code: String
    var tint: Color = .green

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "chevron.left.forwardslash.chevron.right")
                    .foregroundStyle(tint)
                Text("Code Example")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }

            Text(code)
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.secondary)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
        .padding()
        .background(tint.opacity(0.1))
        .cornerRadius(12)
    }
}

struct BulletPoint: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .foregroundStyle(.secondary)
            Text(text)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

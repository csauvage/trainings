import SwiftUI

struct Theme {
    var primaryColor: Color
    var secondaryColor: Color

    static let `default` = Theme(primaryColor: .blue, secondaryColor: .gray)
}

private struct ThemeKey: EnvironmentKey {
    static let defaultValue = Theme.default
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

struct EnvironmentBasicUsage: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 20) {
            Text("Mode: \(colorScheme == .dark ? "Dark" : "Light")")
                .font(.headline)

            Text("Environment values are available throughout the view hierarchy")
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}

#Preview {
    EnvironmentBasicUsage()
}

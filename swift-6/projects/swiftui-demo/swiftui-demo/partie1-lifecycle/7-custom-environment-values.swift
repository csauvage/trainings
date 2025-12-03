import SwiftUI

struct AppTheme {
    var primaryColor: Color
    var secondaryColor: Color

    static let `default` = AppTheme(primaryColor: .blue, secondaryColor: .gray)
    static let premium = AppTheme(primaryColor: .purple, secondaryColor: .pink)
}

// 1. Définir une EnvironmentKey
private struct ThemeKey: EnvironmentKey {
    static let defaultValue = AppTheme.default
}

// 2. Étendre EnvironmentValues
extension EnvironmentValues {
    var appTheme: AppTheme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

// 4. Utiliser dans n'importe quelle View
struct CustomEnvironmentChild: View {
    @Environment(\.appTheme) var theme

    var body: some View {
        Text("Hello")
            .foregroundStyle(theme.primaryColor)
            .padding()
            .background(theme.secondaryColor.opacity(0.2))
            .cornerRadius(10)
    }
}

struct CustomEnvironmentValues: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Default Theme")
                .font(.headline)
            CustomEnvironmentChild()

            Text("Premium Theme")
                .font(.headline)
            CustomEnvironmentChild()
                .environment(\.appTheme, .premium)
        }
        .padding()
    }
}

#Preview {
    CustomEnvironmentValues()
}

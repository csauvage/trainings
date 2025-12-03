import SwiftUI

struct ButtonStylesGlass: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            VStack(spacing: 30) {
                Text("Glass Button Styles")
                    .font(.title)

                // Glass (secondary)
                Button("Glass Action") {
                    // action
                }
                .buttonStyle(.glass)

                // Glass Prominent (primary)
                Button("Glass Prominent") {
                    // action
                }
                .buttonStyle(.glassProminent)

                // With tint
                Button("Colored Glass") {
                    // action
                }
                .tint(.blue)
                .buttonStyle(.glass)

                // Control size variations (optional demo)
                HStack(spacing: 16) {
                    Button("Mini") {}
                        .buttonStyle(.glass)
                        .controlSize(.mini)
                    Button("Small") {}
                        .buttonStyle(.glass)
                        .controlSize(.small)
                    Button("Regular") {}
                        .buttonStyle(.glass)
                        .controlSize(.regular)
                    Button("Large") {}
                        .buttonStyle(.glass)
                        .controlSize(.large)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [
                        Color(hue: 0.60, saturation: 0.16, brightness: 0.96),
                        Color(hue: 0.56, saturation: 0.12, brightness: 0.92)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
        } else {
            // Fallback for older iOS versions: simulate glass-like buttons
            VStack(spacing: 30) {
                Text("Glass Button Styles (Fallback)")
                    .font(.title)

                // Glass button (secondary) - simulated
                Button("Glass Action") {
                    // action
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

                // Glass Prominent (primary) - simulated
                Button("Glass Prominent") {
                    // action
                }
                .padding()
                .background(Color.blue.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(10)

                // With tint - simulated
                Button("Colored Glass") {
                    // action
                }
                .padding()
                .background(Color.blue.opacity(0.2))
                .foregroundColor(.blue)
                .cornerRadius(10)
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
    ButtonStylesGlass()
}

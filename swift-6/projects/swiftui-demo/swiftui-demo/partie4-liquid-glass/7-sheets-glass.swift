import SwiftUI

struct SheetsGlass: View {
    @State private var showSheet = false

    var body: some View {
        if #available(iOS 26.0, *) {
            // iOS 26+: Glass is applied automatically to sheets.
            ZStack {
                // Vivid background makes the sheet’s glass easier to perceive.
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

                Button("Show Sheet") {
                    showSheet = true
                }
                .buttonStyle(.glassProminent) // optional: shows off glass on the trigger too
            }
            .sheet(isPresented: $showSheet) {
                VStack(spacing: 20) {
                    Text("Sheet Content")
                        .font(.title)

                    Text("Glass effect is applied automatically to sheets in iOS 26+")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Spacer()

                    Button("Dismiss") {
                        showSheet = false
                    }
                    .buttonStyle(.glass) // optional: a secondary glass button inside the sheet
                }
                .padding()
                .presentationDetents([.medium, .large])
                // No .presentationBackground() — glass applies automatically on iOS 26+
            }
        } else {
            // Fallback for older iOS versions
            VStack {
                Button("Show Sheet") {
                    showSheet = true
                }
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(10)
            }
            .sheet(isPresented: $showSheet) {
                VStack(spacing: 20) {
                    Text("Sheet Content")
                        .font(.title)

                    Text("This fallback does not apply automatic glass.")
                        .multilineTextAlignment(.center)
                        .padding()

                    Spacer()

                    Button("Dismiss") {
                        showSheet = false
                    }
                }
                .padding()
                .presentationDetents([.medium, .large])
            }
        }
    }
}

#Preview {
    SheetsGlass()
}

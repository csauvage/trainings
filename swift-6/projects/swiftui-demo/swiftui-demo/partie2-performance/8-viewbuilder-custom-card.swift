import SwiftUI

struct Card<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            Divider()
            content()
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct ViewBuilderCustomCard: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Card(title: "Profile") {
                    Text("Name: John")
                    Text("Age: 30")
                    Button("Edit") {
                        // Edit action
                    }
                }

                Card(title: "Settings") {
                    Toggle("Notifications", isOn: .constant(true))
                    Toggle("Dark Mode", isOn: .constant(false))
                }
            }
            .padding()
        }
    }
}

#Preview {
    ViewBuilderCustomCard()
}

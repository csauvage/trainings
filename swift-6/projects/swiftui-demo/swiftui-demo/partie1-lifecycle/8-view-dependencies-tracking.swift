import SwiftUI

struct User {
    var name: String
    var bio: String
}

struct ViewDependenciesTracking: View {
    let user: User
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(user.name) // Dépend de user
                .font(.headline)

            if isExpanded { // Dépend de isExpanded
                Text(user.bio)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            Button(isExpanded ? "Show Less" : "Show More") {
                withAnimation {
                    isExpanded.toggle()
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding()
    }
}

#Preview {
    ViewDependenciesTracking(
        user: User(
            name: "John Doe",
            bio: "SwiftUI developer passionate about building great user experiences."
        )
    )
}

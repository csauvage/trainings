import SwiftUI
import Observation
import Combine

// Ancien (iOS 13-16)
class OldViewModel: ObservableObject {
    @Published var name = ""
    @Published var age = 0
}
// Usage : @StateObject, @ObservedObject

// Nouveau (iOS 17+)
@Observable
class NewViewModel {
    var name = ""
    var age = 0
}
// Usage : @State, @Bindable

struct ObservableComparison: View {
    @State private var newVM = NewViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Observable Comparison Demo")
                .font(.headline)

            VStack {
                Text("New @Observable (iOS 17+)")
                    .font(.subheadline)
                TextField("Name", text: $newVM.name)
                    .textFieldStyle(.roundedBorder)
                Text("Age: \(newVM.age)")
                Button("Increment") {
                    newVM.age += 1
                }
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
        }
        .padding()
    }
}

#Preview {
    ObservableComparison()
}

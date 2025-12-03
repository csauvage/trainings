import SwiftUI
import Observation

@Observable
class ObservableViewModel {
    var name = ""
    var age = 0

    func updateName(_ newName: String) {
        name = newName
    }
}

struct ObservableViewModelDemo: View {
    @State var viewModel = ObservableViewModel()

    var body: some View {
        VStack {
            TextField("Name", text: $viewModel.name)
                .textFieldStyle(.roundedBorder)
                .padding()

            Text("Name: \(viewModel.name)")
            Text("Age: \(viewModel.age)")

            Button("Increment Age") {
                viewModel.age += 1
            }
        }
        .padding()
    }
}

#Preview {
    ObservableViewModelDemo()
}

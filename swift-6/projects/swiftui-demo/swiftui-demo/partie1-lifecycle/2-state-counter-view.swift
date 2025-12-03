import SwiftUI

struct StateCounterView: View {
    @State private var count = 0

    var body: some View {
        Button("Count: \(count)") {
            count += 1 // Déclenche re-render
        }
    }
}

#Preview {
    StateCounterView()
}

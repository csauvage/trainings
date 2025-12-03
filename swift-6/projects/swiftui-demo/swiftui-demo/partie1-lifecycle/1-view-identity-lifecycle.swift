import SwiftUI

struct ViewIdentityLifecycle: View {
    @State private var count = 0

    var body: some View {
        VStack {
            Text("Count: \(count)")
                .id(count) // Force nouvelle identity

            Button("Increment") {
                count += 1
            }
        }
    }
}

#Preview {
    ViewIdentityLifecycle()
}

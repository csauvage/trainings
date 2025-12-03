import SwiftUI

struct BindingParentView: View {
    @State private var isOn = false

    var body: some View {
        VStack {
            Text("Toggle is \(isOn ? "ON" : "OFF")")
            BindingToggleView(isOn: $isOn) // $ = Binding
        }
    }
}

struct BindingToggleView: View {
    @Binding var isOn: Bool

    var body: some View {
        Toggle("Switch", isOn: $isOn)
            .padding()
    }
}

#Preview {
    BindingParentView()
}

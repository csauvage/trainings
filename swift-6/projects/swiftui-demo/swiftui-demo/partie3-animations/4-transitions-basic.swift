import SwiftUI

struct TransitionsBasic: View {
    @State private var show = false

    var body: some View {
        VStack(spacing: 30) {
            if show {
                Text("Hello!")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(10)
                    .transition(.scale.combined(with: .opacity))
            }

            Button("Toggle") {
                withAnimation {
                    show.toggle()
                }
            }
        }
    }
}

#Preview {
    TransitionsBasic()
}

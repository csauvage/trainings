import SwiftUI

struct AnimationBasics: View {
    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 30) {
            Rectangle()
                .fill(.blue)
                .frame(width: isExpanded ? 300 : 100,
                       height: isExpanded ? 300 : 100)
                .animation(.spring(response: 0.6), value: isExpanded)

            Button("Toggle") {
                isExpanded.toggle()
            }
        }
    }
}

#Preview {
    AnimationBasics()
}

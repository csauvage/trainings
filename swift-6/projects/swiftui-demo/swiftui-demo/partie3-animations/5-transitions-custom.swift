import SwiftUI

extension AnyTransition {
    static var slideAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing)
                      .combined(with: .opacity),
            removal: .move(edge: .leading)
                    .combined(with: .opacity)
        )
    }
}

struct TransitionsCustom: View {
    @State private var show = false

    var body: some View {
        VStack(spacing: 30) {
            if show {
                VStack {
                    Text("Detail View")
                        .font(.title)
                    Text("Slides in from trailing")
                        .font(.caption)
                }
                .padding()
                .background(Color.purple.opacity(0.2))
                .cornerRadius(10)
                .transition(.slideAndFade)
            }

            Button("Toggle") {
                withAnimation(.spring()) {
                    show.toggle()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    TransitionsCustom()
}

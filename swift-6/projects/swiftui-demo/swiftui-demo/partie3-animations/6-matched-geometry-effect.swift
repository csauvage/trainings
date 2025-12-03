import SwiftUI

struct MatchedGeometryEffectDemo: View {
    @State private var showDetail = false
    @Namespace private var animation

    var body: some View {
        VStack {
            if !showDetail {
                VStack {
                    Circle()
                        .fill(.blue)
                        .frame(width: 100, height: 100)
                        .matchedGeometryEffect(id: "circle", in: animation)

                    Text("Tap to expand")
                        .font(.caption)
                }
                .onTapGesture {
                    withAnimation(.spring()) {
                        showDetail = true
                    }
                }
            } else {
                VStack {
                    Circle()
                        .fill(.blue)
                        .frame(width: 300, height: 300)
                        .matchedGeometryEffect(id: "circle", in: animation)

                    Text("Tap to collapse")
                        .font(.caption)
                }
                .onTapGesture {
                    withAnimation(.spring()) {
                        showDetail = false
                    }
                }
            }
        }
    }
}

#Preview {
    MatchedGeometryEffectDemo()
}

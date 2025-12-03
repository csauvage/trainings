import SwiftUI

// ✅ BON - Subviews extraites
struct PatternExtractedSubviews: View {
    @State private var items: [ImageItem] = [
        ImageItem(name: "Item 1", description: "Description 1", imageURL: nil),
        ImageItem(name: "Item 2", description: "Description 2", imageURL: nil),
        ImageItem(name: "Item 3", description: "Description 3", imageURL: nil)
    ]

    var body: some View {
        List(items) { item in
            ImageItemRow(item: item)
        }
    }
}

struct ImageItemRow: View {
    let item: ImageItem

    var body: some View {
        HStack {
            Image(systemName: "photo")
                .frame(width: 50, height: 50)
                .background(Color.gray.opacity(0.2))
            VStack(alignment: .leading) {
                Text(item.name).font(.headline)
                Text(item.description).font(.caption)
            }
            Spacer()
            Button("Details") {
                // Action
            }
        }
    }
}

#Preview {
    PatternExtractedSubviews()
}

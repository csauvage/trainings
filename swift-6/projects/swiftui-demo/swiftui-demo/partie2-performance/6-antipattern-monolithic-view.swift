import SwiftUI

struct ImageItem: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var imageURL: URL?
}

// ❌ MAUVAIS - Vue monolithique
struct AntipatternMonolithicView: View {
    @State private var items: [ImageItem] = [
        ImageItem(name: "Item 1", description: "Description 1", imageURL: nil),
        ImageItem(name: "Item 2", description: "Description 2", imageURL: nil),
        ImageItem(name: "Item 3", description: "Description 3", imageURL: nil)
    ]

    var body: some View {
        List(items) { item in
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
}

#Preview {
    AntipatternMonolithicView()
}

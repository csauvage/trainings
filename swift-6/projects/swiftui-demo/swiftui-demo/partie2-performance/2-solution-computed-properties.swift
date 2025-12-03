import SwiftUI

struct ProcessedItem: Identifiable {
    let id = UUID()
    var name: String
}

// ✅ BON - Calcul en computed property
struct SolutionComputedProperties: View {
    @State private var data: [Item] = [
        Item(name: "Item 1", isActive: true),
        Item(name: "Item 2", isActive: false),
        Item(name: "Item 3", isActive: true),
        Item(name: "Item 4", isActive: true),
        Item(name: "Item 5", isActive: false)
    ]

    private var processedData: [Item] {
        data
            .filter { $0.isActive }
            .sorted { $0.name < $1.name }
    }

    var body: some View {
        List(processedData) { item in
            Text(item.name)
        }
    }
}

#Preview {
    SolutionComputedProperties()
}

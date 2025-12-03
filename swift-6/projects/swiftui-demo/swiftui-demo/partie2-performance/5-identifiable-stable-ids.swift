import SwiftUI

struct StableItem: Identifiable {
    let id: UUID
    var name: String

    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}

struct IdentifiableStableIDs: View {
    @State private var items: [StableItem] = [
        StableItem(name: "Item 1"),
        StableItem(name: "Item 2"),
        StableItem(name: "Item 3")
    ]

    var body: some View {
        VStack(spacing: 20) {
            Text("✅ BON - id stable")
                .font(.headline)

            // ✅ BON - id stable via Identifiable
            List(items) { item in
                Text(item.name)
            }

            Text("❌ MAUVAIS - éviter UUID() dans body")
                .font(.headline)
                .foregroundColor(.red)

            // Note: Montré pour exemple éducatif uniquement
            // Ne pas utiliser UUID() à chaque render !
        }
    }
}

#Preview {
    IdentifiableStableIDs()
}

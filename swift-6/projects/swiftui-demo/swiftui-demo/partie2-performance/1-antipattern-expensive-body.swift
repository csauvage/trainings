import SwiftUI

struct ItemAntipattern: Identifiable {
    let id = UUID()
    var name: String
    var isActive: Bool
}

// ❌ MAUVAIS - Calcul lourd dans body
struct AntipatternExpensiveBody: View {
    @State private var data: [ItemAntipattern] = [
        ItemAntipattern(name: "Item 1", isActive: true),
        ItemAntipattern(name: "Item 2", isActive: false),
        ItemAntipattern(name: "Item 3", isActive: true),
        ItemAntipattern(name: "Item 4", isActive: true),
        ItemAntipattern(name: "Item 5", isActive: false)
    ]

    var body: some View {
        let processedData = data
            .filter { $0.isActive }
            .sorted { $0.name < $1.name }
            .map { $0 } // Représente un calcul lourd

        List(processedData) { item in
            Text(item.name)
        }
    }
}

#Preview {
    AntipatternExpensiveBody()
}

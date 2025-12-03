import SwiftUI
import Observation

struct Item: Identifiable {
    let id = UUID()
    var name: String
    var isActive: Bool
}

@Observable
class ListViewModel {
    private(set) var processedData: [Item] = []

    var rawData: [Item] = [] {
        didSet {
            updateProcessedData()
        }
    }

    init() {
        self.rawData = [
            Item(name: "Item 1", isActive: true),
            Item(name: "Item 2", isActive: false),
            Item(name: "Item 3", isActive: true),
            Item(name: "Item 4", isActive: true),
            Item(name: "Item 5", isActive: false)
        ]
        updateProcessedData()
    }

    private func updateProcessedData() {
        processedData = rawData
            .filter { $0.isActive }
            .sorted { $0.name < $1.name }
    }
}

struct ViewModelObservablePattern: View {
    @State private var viewModel = ListViewModel()

    var body: some View {
        List(viewModel.processedData) { item in
            Text(item.name)
        }
    }
}

#Preview {
    ViewModelObservablePattern()
}

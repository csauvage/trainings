import SwiftUI

// MARK: - Data Models

struct DemoScript: Identifiable {
    let id = UUID()
    let number: Int
    let title: String
    let description: String
    let view: AnyView

    init(number: Int, title: String, description: String, view: some View) {
        self.number = number
        self.title = title
        self.description = description
        self.view = AnyView(view)
    }
}

struct Partie: Identifiable {
    let id = UUID()
    let number: Int
    let title: String
    let scripts: [DemoScript]
}

import SwiftUI
import SwiftData

@main
struct MindfulApp: App {
    @State private var dataController = DataController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(dataController.container)
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "book.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Mindful Journal")
                .font(.largeTitle)
                .padding()
            Text("Day 1: Core Architecture Ready")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .modelContainer(DataController.preview.container)
}

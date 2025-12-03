import SwiftUI

struct NavigationItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

struct NavigationSplitViewGlass: View {
    @State private var items: [NavigationItem] = [
        NavigationItem(name: "Item 1"),
        NavigationItem(name: "Item 2"),
        NavigationItem(name: "Item 3")
    ]
    @State private var selectedItem: NavigationItem?

    var body: some View {
        if #available(iOS 26.0, *) {
            // iOS 26:
            // - Sidebar floats above content with glass.
            // - .backgroundExtensionEffect() extends the detail background under the sidebar.
            // - Content mirrors and blurs outside the safe area (more visible on iPad).
            NavigationSplitView {
                // Sidebar
                List(items) { item in
                    NavigationLink(item.name, value: item)
                }
                .navigationTitle("Items")
                .backgroundExtensionEffect()
            } detail: {
                // Default detail when no selection yet
                DetailBackgroundDemo {
                    Text("Select an item")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }
            // Value-based destination for NavigationLink(value:)
            .navigationDestination(for: NavigationItem.self) { item in
                DetailBackgroundDemo {
                    DetailContentView(item: item)
                }
            }
        } else {
            // Fallback for older iOS versions (without backgroundExtensionEffect)
            NavigationSplitView {
                List(items, selection: $selectedItem) { item in
                    Text(item.name)
                }
                .navigationTitle("Items")
            } detail: {
                if let item = selectedItem {
                    DetailContentView(item: item)
                } else {
                    Text("Select an item")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

// A simple wrapper to give the detail area a vivid background so the
// extended/blurred/mirrored effect is easy to see under the glass sidebar.
private struct DetailBackgroundDemo<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hue: 0.60, saturation: 0.25, brightness: 0.95),
                    Color(hue: 0.55, saturation: 0.30, brightness: 0.90),
                    Color(hue: 0.50, saturation: 0.35, brightness: 0.88)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            content()
                .padding()
        }
    }
}

struct DetailContentView: View {
    let item: NavigationItem

    var body: some View {
        VStack(spacing: 12) {
            Text(item.name)
                .font(.largeTitle.bold())
            Text("Detail content")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationSplitViewGlass()
}

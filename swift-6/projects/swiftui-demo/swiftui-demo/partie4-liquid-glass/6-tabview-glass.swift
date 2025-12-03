import SwiftUI

struct TabViewGlass: View {
    @State private var selectedTab = 0

    var body: some View {
        if #available(iOS 26.0, *) {
            // iOS 26+:
            // - Tab bar floats with a glass appearance.
            // - .tabBarMinimizeBehavior(.onScrollDown) hides the bar as you scroll content.
            // - .tabViewBottomAccessory adds persistent content above the tab bar (also glass).
            // Note: The floating glass look is especially visible on iPad.
            TabView(selection: $selectedTab) {
                HomeTabView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)

                SearchTabView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(1)

                ProfileTabView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                    .tag(2)
            }
            .tabBarMinimizeBehavior(.onScrollDown)
            .tabViewBottomAccessory {
                NowPlayingView()
            }
        } else {
            // Fallback for older iOS versions (no floating/minimizing glass tab bar)
            TabView(selection: $selectedTab) {
                HomeTabView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)

                SearchTabView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(1)

                ProfileTabView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                    .tag(2)
            }
        }
    }
}

struct HomeTabView: View {
    var body: some View {
        NavigationStack {
            // Use a scrollable view so the tab bar can minimize on scroll (iOS 26+).
            List(0..<40, id: \.self) { i in
                Text("Home Row \(i)")
            }
            .navigationTitle("Home")
        }
    }
}

struct SearchTabView: View {
    var body: some View {
        NavigationStack {
            List(0..<30, id: \.self) { i in
                Text("Search Result \(i)")
            }
            .navigationTitle("Search")
        }
    }
}

struct ProfileTabView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(0..<20, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.1))
                            .frame(height: 80)
                            .overlay(Text("Profile Card \(i)").foregroundStyle(.secondary))
                    }
                }
                .padding()
            }
            .navigationTitle("Profile")
        }
    }
}

@available(iOS 26.0, *)
private struct NowPlayingView: View {
    @State private var isPlaying = true

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "music.note.list")
                .font(.title3)
                .frame(width: 28, height: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text("Now Playing")
                    .font(.subheadline.bold())
                Text("SwiftUI Lo-Fi Beats")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
                isPlaying.toggle()
            } label: {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.headline)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        // Give the accessory a subtle glass look.
        .glassEffect(.regular, in: .capsule)
    }
}

#Preview {
    TabViewGlass()
}

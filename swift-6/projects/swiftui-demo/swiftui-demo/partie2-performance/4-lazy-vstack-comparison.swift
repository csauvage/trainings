import SwiftUI

struct HeavyView: View {
    let number: Int

    var body: some View {
        Text("Heavy View #\(number)")
            .padding()
            .background(Color.blue.opacity(0.2))
    }
}

struct LazyVStackComparison: View {
    @State private var useLazy = true

    var body: some View {
        VStack {
            Toggle("Use LazyVStack", isOn: $useLazy)
                .padding()

            if useLazy {
                // LazyVStack - Créés seulement quand visibles
                ScrollView {
                    LazyVStack {
                        ForEach(1...50, id: \.self) { i in
                            HeavyView(number: i) // Seulement ~20 à la fois
                        }
                    }
                }
            } else {
                // VStack - Tous les enfants créés immédiatement
                ScrollView {
                    VStack {
                        ForEach(1...50, id: \.self) { i in
                            HeavyView(number: i) // 50 Views créées !
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    LazyVStackComparison()
}

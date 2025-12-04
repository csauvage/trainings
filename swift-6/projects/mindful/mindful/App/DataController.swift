import Foundation
import SwiftData

/// Manages SwiftData configuration and provides access to the model container
@MainActor
final class DataController: Sendable {
    static let shared = DataController()

    let container: ModelContainer

    private init() {
        let schema = Schema([
            JournalEntry.self,
            Photo.self,
            Tag.self
        ])

        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            allowsSave: true,
            cloudKitDatabase: .automatic
        )

        do {
            container = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var mainContext: ModelContext {
        container.mainContext
    }

    func createBackgroundContext() -> ModelContext {
        ModelContext(container)
    }

    static var preview: DataController {
        let controller = DataController.previewInstance
        let context = controller.mainContext

        let sampleEntry1 = JournalEntry(
            title: "Belle matinée",
            content: "Je me suis réveillé devant un magnifique lever de soleil aujourd'hui. Le ciel était peint de nuances de rose et d'orange. Je me suis senti reconnaissant pour ce moment paisible.",
            mood: .happy,
            location: Location(
                latitude: 37.7749,
                longitude: -122.4194,
                placeName: "Parc du Golden Gate",
                city: "San Francisco",
                country: "États-Unis"
            ),
            weather: Weather(
                temperature: 18.5,
                condition: .clear
            )
        )
        sampleEntry1.updateWordCount()

        let sampleEntry2 = JournalEntry(
            title: "Pensées d'un jour de pluie",
            content: "Il a plu toute la journée. Je suis resté à l'intérieur et j'ai réfléchi à la semaine passée. Parfois, les moments de calme sont les plus précieux.",
            mood: .neutral,
            weather: Weather(
                temperature: 12.0,
                condition: .rainy
            )
        )
        sampleEntry2.updateWordCount()

        let sampleEntry3 = JournalEntry(
            title: "Concert incroyable",
            content: "Je suis allé voir mon groupe préféré ce soir ! L'énergie était incroyable. C'est pour ces moments-là que je vis.",
            mood: .veryHappy,
            isFavorite: true
        )
        sampleEntry3.updateWordCount()

        let tag1 = Tag(name: "Reconnaissance", color: "#FFD700")
        let tag2 = Tag(name: "Musique", color: "#FF6B6B")
        let tag3 = Tag(name: "Nature", color: "#4ECDC4")

        sampleEntry1.tags.append(tag1)
        sampleEntry1.tags.append(tag3)
        sampleEntry3.tags.append(tag2)

        context.insert(sampleEntry1)
        context.insert(sampleEntry2)
        context.insert(sampleEntry3)
        context.insert(tag1)
        context.insert(tag2)
        context.insert(tag3)

        return controller
    }

    private static var previewInstance: DataController {
        let schema = Schema([
            JournalEntry.self,
            Photo.self,
            Tag.self
        ])

        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true
        )

        let container = try! ModelContainer(
            for: schema,
            configurations: [configuration]
        )

        return DataController.previewContainer(container)
    }

    private static func previewContainer(_ container: ModelContainer) -> DataController {
        let controller = DataController(__preview: container)
        return controller
    }

    private init(__preview container: ModelContainer) {
        self.container = container
    }
}

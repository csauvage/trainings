import Foundation
import SwiftData

/// Main model representing a journal entry
@Model
final class JournalEntry {
    @Attribute(.unique) var id: UUID
    var title: String
    var content: String
    var createdAt: Date
    var modifiedAt: Date
    var mood: Mood?
    var location: Location?
    var weather: Weather?
    var isFavorite: Bool
    var wordCount: Int

    @Relationship(deleteRule: .cascade) var photos: [Photo]
    @Relationship var tags: [Tag]

    init(
        id: UUID = UUID(),
        title: String = "",
        content: String = "",
        createdAt: Date = Date(),
        modifiedAt: Date = Date(),
        mood: Mood? = nil,
        location: Location? = nil,
        weather: Weather? = nil,
        isFavorite: Bool = false,
        wordCount: Int = 0,
        photos: [Photo] = [],
        tags: [Tag] = []
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.mood = mood
        self.location = location
        self.weather = weather
        self.isFavorite = isFavorite
        self.wordCount = wordCount
        self.photos = photos
        self.tags = tags
    }

    func updateWordCount() {
        let words = content.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
        self.wordCount = words.count
    }

    var displayTitle: String {
        if !title.isEmpty {
            return title
        }
        let preview = content.prefix(50)
        return preview.isEmpty ? "Untitled Entry" : String(preview)
    }

    var readingTime: Int {
        let wordsPerMinute = 200
        return max(1, wordCount / wordsPerMinute)
    }
}

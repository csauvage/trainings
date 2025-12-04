import Foundation
import SwiftData

/// Thread-safe repository for managing journal entries
actor JournalRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func create(
        title: String = "",
        content: String = "",
        mood: Mood? = nil,
        location: Location? = nil,
        weather: Weather? = nil
    ) async throws -> JournalEntry {
        let entry = JournalEntry(
            title: title,
            content: content,
            mood: mood,
            location: location,
            weather: weather
        )
        entry.updateWordCount()

        modelContext.insert(entry)
        try modelContext.save()

        return entry
    }

    func fetch(id: UUID) async throws -> JournalEntry? {
        let descriptor = FetchDescriptor<JournalEntry>(
            predicate: #Predicate { entry in
                entry.id == id
            }
        )
        return try modelContext.fetch(descriptor).first
    }

    func fetchAll(
        sortBy: SortOrder = .dateDescending,
        limit: Int? = nil
    ) async throws -> [JournalEntry] {
        var descriptor = FetchDescriptor<JournalEntry>()

        switch sortBy {
        case .dateDescending:
            descriptor.sortBy = [SortDescriptor(\.createdAt, order: .reverse)]
        case .dateAscending:
            descriptor.sortBy = [SortDescriptor(\.createdAt, order: .forward)]
        case .titleAscending:
            descriptor.sortBy = [SortDescriptor(\.title, order: .forward)]
        case .modifiedDate:
            descriptor.sortBy = [SortDescriptor(\.modifiedAt, order: .reverse)]
        }

        if let limit = limit {
            descriptor.fetchLimit = limit
        }

        return try modelContext.fetch(descriptor)
    }

    func search(query: String) async throws -> [JournalEntry] {
        let lowercasedQuery = query.lowercased()
        let descriptor = FetchDescriptor<JournalEntry>(
            predicate: #Predicate { entry in
                entry.title.localizedStandardContains(lowercasedQuery) ||
                entry.content.localizedStandardContains(lowercasedQuery)
            }
        )

        return try modelContext.fetch(descriptor)
    }

    func fetchByMood(_ mood: Mood) async throws -> [JournalEntry] {
        let descriptor = FetchDescriptor<JournalEntry>(
            predicate: #Predicate { entry in
                entry.mood == mood
            },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        return try modelContext.fetch(descriptor)
    }

    func fetchByDateRange(from startDate: Date, to endDate: Date) async throws -> [JournalEntry] {
        let descriptor = FetchDescriptor<JournalEntry>(
            predicate: #Predicate { entry in
                entry.createdAt >= startDate && entry.createdAt <= endDate
            },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        return try modelContext.fetch(descriptor)
    }

    func fetchFavorites() async throws -> [JournalEntry] {
        let descriptor = FetchDescriptor<JournalEntry>(
            predicate: #Predicate { entry in
                entry.isFavorite == true
            },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        return try modelContext.fetch(descriptor)
    }

    func update(_ entry: JournalEntry) async throws {
        entry.modifiedAt = Date()
        entry.updateWordCount()
        try modelContext.save()
    }

    func delete(_ entry: JournalEntry) async throws {
        modelContext.delete(entry)
        try modelContext.save()
    }

    func deleteMultiple(_ entries: [JournalEntry]) async throws {
        for entry in entries {
            modelContext.delete(entry)
        }
        try modelContext.save()
    }

    func toggleFavorite(_ entry: JournalEntry) async throws {
        entry.isFavorite.toggle()
        entry.modifiedAt = Date()
        try modelContext.save()
    }

    func addTag(_ tag: Tag, to entry: JournalEntry) async throws {
        if !entry.tags.contains(where: { $0.id == tag.id }) {
            entry.tags.append(tag)
            entry.modifiedAt = Date()
            try modelContext.save()
        }
    }

    func removeTag(_ tag: Tag, from entry: JournalEntry) async throws {
        entry.tags.removeAll { $0.id == tag.id }
        entry.modifiedAt = Date()
        try modelContext.save()
    }

    func count() async throws -> Int {
        let descriptor = FetchDescriptor<JournalEntry>()
        return try modelContext.fetchCount(descriptor)
    }

    func totalWordCount() async throws -> Int {
        let entries = try await fetchAll()
        return entries.reduce(0) { $0 + $1.wordCount }
    }
}

enum SortOrder: Sendable {
    case dateDescending
    case dateAscending
    case titleAscending
    case modifiedDate
}

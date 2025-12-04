import Foundation
import SwiftData

/// Represents a photo attached to a journal entry
@Model
final class Photo {
    @Attribute(.unique) var id: UUID
    var imageData: Data
    var thumbnailData: Data?
    var caption: String?
    var takenAt: Date
    var fileSize: Int
    var width: Int
    var height: Int

    @Relationship(deleteRule: .nullify, inverse: \JournalEntry.photos)
    var journalEntry: JournalEntry?

    init(
        id: UUID = UUID(),
        imageData: Data,
        thumbnailData: Data? = nil,
        caption: String? = nil,
        takenAt: Date = Date(),
        fileSize: Int = 0,
        width: Int = 0,
        height: Int = 0
    ) {
        self.id = id
        self.imageData = imageData
        self.thumbnailData = thumbnailData
        self.caption = caption
        self.takenAt = takenAt
        self.fileSize = fileSize
        self.width = width
        self.height = height
    }

    var aspectRatio: Double {
        guard height > 0 else { return 1.0 }
        return Double(width) / Double(height)
    }

    var fileSizeFormatted: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(fileSize))
    }
}

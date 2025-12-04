import Foundation
import SwiftData
import UIKit

/// Thread-safe service for processing and managing photos
actor PhotoProcessor {
    private let modelContext: ModelContext
    private let maxImageSize: CGFloat = 2048
    private let thumbnailSize: CGFloat = 300
    private let compressionQuality: CGFloat = 0.8

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func processImage(
        _ image: UIImage,
        caption: String? = nil,
        for entry: JournalEntry
    ) async throws -> Photo {
        let processedImageData = try await processFullSizeImage(image)
        let thumbnailData = try await generateThumbnail(from: image)

        let photo = Photo(
            imageData: processedImageData,
            thumbnailData: thumbnailData,
            caption: caption,
            takenAt: Date(),
            fileSize: processedImageData.count,
            width: Int(image.size.width),
            height: Int(image.size.height)
        )

        photo.journalEntry = entry
        entry.photos.append(photo)

        modelContext.insert(photo)
        try modelContext.save()

        return photo
    }

    func processMultipleImages(
        _ images: [UIImage],
        for entry: JournalEntry
    ) async throws -> [Photo] {
        var photos: [Photo] = []

        for image in images {
            let photo = try await processImage(image, for: entry)
            photos.append(photo)
        }

        return photos
    }

    private func processFullSizeImage(_ image: UIImage) async throws -> Data {
        guard let resizedImage = await resize(image, maxSize: maxImageSize) else {
            throw PhotoProcessorError.resizeFailed
        }

        guard let imageData = resizedImage.jpegData(compressionQuality: compressionQuality) else {
            throw PhotoProcessorError.compressionFailed
        }

        return imageData
    }

    private func generateThumbnail(from image: UIImage) async throws -> Data {
        guard let thumbnailImage = await resize(image, maxSize: thumbnailSize) else {
            throw PhotoProcessorError.thumbnailFailed
        }

        guard let thumbnailData = thumbnailImage.jpegData(compressionQuality: 0.7) else {
            throw PhotoProcessorError.compressionFailed
        }

        return thumbnailData
    }

    private func resize(_ image: UIImage, maxSize: CGFloat) async -> UIImage? {
        let size = image.size
        let widthRatio = maxSize / size.width
        let heightRatio = maxSize / size.height
        let ratio = min(widthRatio, heightRatio, 1.0)

        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        return await MainActor.run {
            let renderer = UIGraphicsImageRenderer(size: newSize)
            return renderer.image { _ in
                image.draw(in: CGRect(origin: .zero, size: newSize))
            }
        }
    }

    func updateCaption(_ photo: Photo, caption: String?) async throws {
        photo.caption = caption
        try modelContext.save()
    }

    func delete(_ photo: Photo) async throws {
        modelContext.delete(photo)
        try modelContext.save()
    }

    func deleteMultiple(_ photos: [Photo]) async throws {
        for photo in photos {
            modelContext.delete(photo)
        }
        try modelContext.save()
    }

    func loadImage(from photo: Photo) async throws -> UIImage {
        guard let image = UIImage(data: photo.imageData) else {
            throw PhotoProcessorError.invalidImageData
        }
        return image
    }

    func loadThumbnail(from photo: Photo) async throws -> UIImage {
        if let thumbnailData = photo.thumbnailData,
           let thumbnail = UIImage(data: thumbnailData) {
            return thumbnail
        }

        return try await loadImage(from: photo)
    }

    func calculateTotalStorageSize(for entry: JournalEntry) async -> Int {
        entry.photos.reduce(0) { $0 + $1.fileSize }
    }

    func optimizeStorage(for photo: Photo, compressionQuality: CGFloat = 0.6) async throws {
        guard let image = UIImage(data: photo.imageData),
              let optimizedData = image.jpegData(compressionQuality: compressionQuality) else {
            throw PhotoProcessorError.compressionFailed
        }

        photo.imageData = optimizedData
        photo.fileSize = optimizedData.count
        try modelContext.save()
    }
}

enum PhotoProcessorError: Error, LocalizedError, Sendable {
    case resizeFailed
    case compressionFailed
    case thumbnailFailed
    case invalidImageData

    var errorDescription: String? {
        switch self {
        case .resizeFailed:
            return "Failed to resize image"
        case .compressionFailed:
            return "Failed to compress image"
        case .thumbnailFailed:
            return "Failed to generate thumbnail"
        case .invalidImageData:
            return "Invalid image data"
        }
    }
}

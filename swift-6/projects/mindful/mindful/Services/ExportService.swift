import Foundation
import PDFKit
import UIKit

typealias PlatformImage = UIImage

actor ExportService {

    // MARK: - Public API

    func exportJSON(for entry: JournalEntry) async throws -> Data? {
        return nil
    }

    func exportCSV(for entry: JournalEntry) async throws -> Data? {
        return nil
    }

    func exportMarkdown(for entry: JournalEntry) async -> Data {
        let md = await makeMarkdown(from: entry)
        return Data(md.utf8)
    }

    @MainActor
    func exportPDF(for entry: JournalEntry, pageSize: CGSize = CGSize(width: 612, height: 792), margins: UIEdgeInsetsLike = .init(top: 48, left: 48, bottom: 48, right: 48)) async throws -> Data {
        let pdfMeta: [String: Any] = [
            kCGPDFContextCreator as String: "ExportService",
            kCGPDFContextTitle as String: entry.displayTitle
        ]

        let data = NSMutableData()
        guard let consumer = CGDataConsumer(data: data as CFMutableData) else {
            throw ExportError.pdfContextFailed
        }
        var mediaBox = CGRect(origin: .zero, size: pageSize)
        guard let ctx = CGContext(consumer: consumer, mediaBox: &mediaBox, pdfMeta as CFDictionary) else {
            throw ExportError.pdfContextFailed
        }

        // Prepare content blocks
        let content = PDFContent(
            title: entry.displayTitle,
            createdAt: entry.createdAt,
            modifiedAt: entry.modifiedAt,
            mood: entry.mood,
            location: entry.location,
            weather: entry.weather,
            tags: entry.tags.map { $0.name },
            body: entry.content,
            photos: entry.photos
        )

        // Render pages
        let renderer = PDFRenderer(pageSize: pageSize, margins: margins)
        try await renderer.render(content: content, in: ctx)

        ctx.closePDF()
        return data as Data
    }

    // MARK: - DTO

    private struct ExportableJournalEntry: Codable, Sendable {
        let id: UUID
        let title: String
        let content: String
        let createdAt: Date
        let modifiedAt: Date
        let mood: String?
        let moodEmoji: String?
        let location: ExportableLocation?
        let weather: ExportableWeather?
        let isFavorite: Bool
        let wordCount: Int
        let tags: [String]
        let photos: [ExportablePhoto]
    }

    private struct ExportableLocation: Codable, Sendable {
        let latitude: Double
        let longitude: Double
        let placeName: String?
        let city: String?
        let country: String?
        let displayName: String
    }

    private struct ExportableWeather: Codable, Sendable {
        let temperatureCelsius: Double
        let condition: String
        let conditionDisplay: String
        let conditionEmoji: String
        let humidity: Double?
        let windSpeed: Double?
        let timestamp: Date
    }

    private struct ExportablePhoto: Codable, Sendable {
        let id: UUID
        let caption: String?
        let takenAt: Date
        let fileSize: Int
        let width: Int
        let height: Int
    }

    @MainActor
    private func makeDTO(from entry: JournalEntry) -> ExportableJournalEntry {
        ExportableJournalEntry(
            id: entry.id,
            title: entry.displayTitle,
            content: entry.content,
            createdAt: entry.createdAt,
            modifiedAt: entry.modifiedAt,
            mood: entry.mood?.rawValue,
            moodEmoji: entry.mood?.emoji,
            location: entry.location.map { loc in
                ExportableLocation(
                    latitude: loc.latitude,
                    longitude: loc.longitude,
                    placeName: loc.placeName,
                    city: loc.city,
                    country: loc.country,
                    displayName: loc.displayName
                )
            },
            weather: entry.weather.map { w in
                ExportableWeather(
                    temperatureCelsius: w.temperatureCelsius,
                    condition: w.condition.rawValue,
                    conditionDisplay: w.condition.displayName,
                    conditionEmoji: w.condition.emoji,
                    humidity: w.humidity,
                    windSpeed: w.windSpeed,
                    timestamp: w.timestamp
                )
            },
            isFavorite: entry.isFavorite,
            wordCount: entry.wordCount,
            tags: entry.tags.map { $0.name },
            photos: entry.photos.map { p in
                ExportablePhoto(
                    id: p.id,
                    caption: p.caption,
                    takenAt: p.takenAt,
                    fileSize: p.fileSize,
                    width: p.width,
                    height: p.height
                )
            }
        )
    }

    // MARK: - CSV

    private func csvHeaders() -> [String] {
        [
            "id",
            "title",
            "content",
            "createdAt",
            "modifiedAt",
            "mood",
            "moodEmoji",
            "location",
            "weather",
            "isFavorite",
            "wordCount",
            "tags",
            "photosCount"
        ]
    }

    private func csvRow(from dto: ExportableJournalEntry) async  -> [String] {
        let iso = await ISO8601DateFormatter.fractional()

        let locationString: String = {
            guard let loc = dto.location else { return "" }
            return "\(loc.displayName) (\(loc.latitude),\(loc.longitude))"
        }()

        let weatherString: String = {
            guard let w = dto.weather else { return "" }
            return "\(w.conditionDisplay) \(w.conditionEmoji) \(String(format: "%.1f", w.temperatureCelsius))°C"
        }()

        return [
            csvEscape(dto.id.uuidString),
            csvEscape(dto.title),
            csvEscape(dto.content),
            csvEscape(iso.string(from: dto.createdAt)),
            csvEscape(iso.string(from: dto.modifiedAt)),
            csvEscape(dto.mood ?? ""),
            csvEscape(dto.moodEmoji ?? ""),
            csvEscape(locationString),
            csvEscape(weatherString),
            csvEscape(dto.isFavorite ? "true" : "false"),
            csvEscape(String(dto.wordCount)),
            csvEscape(dto.tags.joined(separator: ";")),
            csvEscape(String(dto.photos.count))
        ]
    }

    private func csvEscape(_ value: String) -> String {
        var v = value.replacingOccurrences(of: "\"", with: "\"\"")
        if v.contains(",") || v.contains("\"") || v.contains("\n") || v.contains("\r") {
            v = "\"\(v)\""
        }
        return v
    }

    // MARK: - Markdown

    @MainActor
    private func makeMarkdown(from entry: JournalEntry) -> String {
        var lines: [String] = []
        let iso = ISO8601DateFormatter.fractional()

        lines.append("# \(entry.displayTitle)")
        lines.append("")
        lines.append("- Created: \(iso.string(from: entry.createdAt))")
        lines.append("- Modified: \(iso.string(from: entry.modifiedAt))")
        if let mood = entry.mood {
            lines.append("- Mood: \(mood.displayName) \(mood.emoji)")
        }
        if let weather = entry.weather {
            lines.append("- Weather: \(weather.condition.displayName) \(weather.condition.emoji), \(String(format: "%.1f", weather.temperatureCelsius))°C")
        }
        if let location = entry.location {
            lines.append("- Location: \(location.displayName) (\(String(format: "%.4f", location.latitude)), \(String(format: "%.4f", location.longitude)))")
        }
        if !entry.tags.isEmpty {
            lines.append("- Tags: " + entry.tags.map { $0.name }.joined(separator: ", "))
        }
        lines.append("- Favorite: \(entry.isFavorite ? "Yes" : "No")")
        lines.append("- Word Count: \(entry.wordCount)")
        lines.append("")
        lines.append("---")
        lines.append("")
        lines.append(entry.content)
        lines.append("")
        if !entry.photos.isEmpty {
            lines.append("## Photos")
            for (idx, photo) in entry.photos.enumerated() {
                let caption = photo.caption ?? "Photo \(idx + 1)"
                lines.append("- \(caption) • \(photo.fileSizeFormatted) • \(photo.width)x\(photo.height)")
            }
            lines.append("")
        }

        return lines.joined(separator: "\n")
    }

    // MARK: - Helpers

    private enum ExportError: Error {
        case encodingFailed
        case pdfContextFailed
        case imageDecodeFailed
    }

    struct UIEdgeInsetsLike: Sendable {
        var top: CGFloat
        var left: CGFloat
        var bottom: CGFloat
        var right: CGFloat

        init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
            self.top = top
            self.left = left
            self.bottom = bottom
            self.right = right
        }
    }

    private struct PDFContent {
        let title: String
        let createdAt: Date
        let modifiedAt: Date
        let mood: Mood?
        let location: Location?
        let weather: Weather?
        let tags: [String]
        let body: String
        let photos: [Photo]
    }

    @MainActor
    private final class PDFRenderer {
        private let pageSize: CGSize
        private let margins: UIEdgeInsetsLike
        private let contentWidth: CGFloat

        init(pageSize: CGSize, margins: UIEdgeInsetsLike) {
            self.pageSize = pageSize
            self.margins = margins
            self.contentWidth = pageSize.width - margins.left - margins.right
        }

        func render(content: PDFContent, in ctx: CGContext) async throws {
            
        }

        private func draw(text: String, at origin: CGPoint, font: PDFFont, color: PDFColor, maxWidth: CGFloat, in ctx: CGContext) -> CGPoint {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.alignment = .left

            let attrs: [NSAttributedString.Key: Any] = [
                .font: font.platformFont,
                .foregroundColor: color.platformColor,
                .paragraphStyle: paragraphStyle
            ]

            let attributed = NSAttributedString(string: text, attributes: attrs)
            let bounding = attributed.boundingRect(with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)

            let textRect = CGRect(origin: origin, size: CGSize(width: maxWidth, height: ceil(bounding.height)))
            UIGraphicsPushContext(ctx)
            attributed.draw(with: textRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
            UIGraphicsPopContext()

            return CGPoint(x: origin.x, y: origin.y + ceil(bounding.height) + 4)
        }

        private func draw(image: PlatformImage, in rect: CGRect, context ctx: CGContext) {
            UIGraphicsPushContext(ctx)
            image.draw(in: rect)
            UIGraphicsPopContext()
        }

        private func decodeImage(from photo: Photo) -> PlatformImage? {
            if let thumb = photo.thumbnailData, let img = UIImage(data: thumb) {
                return img
            }
            return UIImage(data: photo.imageData)
        }
    }
}

// MARK: - Utilities

private extension JSONEncoder.DateEncodingStrategy {
    static var iso8601WithFractional: JSONEncoder.DateEncodingStrategy {
        .custom { date, encoder in
            var container = encoder.singleValueContainer()
            try! container.encode(ISO8601DateFormatter.fractional().string(from: date))
        }
    }
}

private extension ISO8601DateFormatter {
    static func fractional() -> ISO8601DateFormatter {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }
}

// Lightweight font/color wrappers for PDF text drawing (UIKit-only)
private struct PDFFont {
    let platformFont: UIFont

    static func system(_ size: CGFloat) -> PDFFont {
        PDFFont(platformFont: UIFont.systemFont(ofSize: size))
    }

    static func boldSystem(_ size: CGFloat) -> PDFFont {
        PDFFont(platformFont: UIFont.boldSystemFont(ofSize: size))
    }
}

private struct PDFColor {
    let platformColor: UIColor

    static var black: PDFColor {
        PDFColor(platformColor: UIColor.label)
    }

    static var darkGray: PDFColor {
        PDFColor(platformColor: UIColor.darkGray)
    }
}

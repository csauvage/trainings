import Foundation
import NaturalLanguage

/// Thread-safe service for analyzing sentiment and extracting keywords from journal entries
actor SentimentAnalyzer {

    func analyzeSentiment(from text: String) async -> SentimentResult {
        guard !text.isEmpty else {
            return SentimentResult(mood: .neutral, confidence: 0.0, sentiment: 0.0)
        }

        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text

        var totalSentiment: Double = 0
        var sentenceCount: Double = 0

        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .paragraph, scheme: .sentimentScore) { tag, _ in
            if let tag = tag,
               let score = Double(tag.rawValue) {
                totalSentiment += score
                sentenceCount += 1
            }
            return true
        }

        guard sentenceCount > 0 else {
            return SentimentResult(mood: .neutral, confidence: 0.0, sentiment: 0.0)
        }

        let averageSentiment = totalSentiment / sentenceCount
        let mood = moodFromSentiment(averageSentiment)
        let confidence = abs(averageSentiment)

        return SentimentResult(mood: mood, confidence: confidence, sentiment: averageSentiment)
    }

    func extractKeywords(from text: String, limit: Int = 10) async -> [String] {
        guard !text.isEmpty else { return [] }

        let tagger = NLTagger(tagSchemes: [.nameType, .lexicalClass])
        tagger.string = text

        var keywords: Set<String> = []

        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lexicalClass) { tag, range in
            if let tag = tag {
                let word = String(text[range])

                if tag == .noun || tag == .verb || tag == .adjective {
                    if word.count > 3 && !isStopWord(word) {
                        keywords.insert(word.lowercased())
                    }
                }
            }
            return true
        }

        let sortedKeywords = Array(keywords.prefix(limit))
        return sortedKeywords
    }

    func extractEntities(from text: String) async -> [Entity] {
        guard !text.isEmpty else { return [] }

        let tagger = NLTagger(tagSchemes: [.nameType])
        tagger.string = text

        var entities: [Entity] = []

        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .nameType) { tag, range in
            if let tag = tag {
                let name = String(text[range])
                let entityType = entityTypeFromTag(tag)
                entities.append(Entity(name: name, type: entityType))
            }
            return true
        }

        return entities
    }

    func suggestMood(from text: String) async -> Mood? {
        let result = await analyzeSentiment(from: text)
        return result.confidence > 0.2 ? result.mood : nil
    }

    func generateSummary(from text: String, maxSentences: Int = 3) async -> String {
        guard !text.isEmpty else { return "" }

        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text

        var sentences: [String] = []
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            sentences.append(String(text[range]))
            return sentences.count < maxSentences
        }

        return sentences.joined(separator: " ")
    }

    func detectLanguage(from text: String) async -> String? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)

        guard let language = recognizer.dominantLanguage else {
            return nil
        }

        return language.rawValue
    }

    private func moodFromSentiment(_ sentiment: Double) -> Mood {
        switch sentiment {
        case 0.5...:
            return .veryHappy
        case 0.2..<0.5:
            return .happy
        case -0.2...0.2:
            return .neutral
        case -0.5..<(-0.2):
            return .sad
        default:
            return .verySad
        }
    }

    private func entityTypeFromTag(_ tag: NLTag) -> EntityType {
        switch tag {
        case .personalName:
            return .person
        case .placeName:
            return .place
        case .organizationName:
            return .organization
        default:
            return .other
        }
    }

    private func isStopWord(_ word: String) -> Bool {
        let stopWords: Set<String> = [
            "the", "be", "to", "of", "and", "a", "in", "that", "have", "i",
            "it", "for", "not", "on", "with", "he", "as", "you", "do", "at",
            "this", "but", "his", "by", "from", "they", "we", "say", "her", "she",
            "or", "an", "will", "my", "one", "all", "would", "there", "their"
        ]
        return stopWords.contains(word.lowercased())
    }
}

struct SentimentResult: Sendable {
    let mood: Mood
    let confidence: Double
    let sentiment: Double

    var description: String {
        "\(mood.displayName) (confidence: \(String(format: "%.2f", confidence)))"
    }
}

struct Entity: Sendable, Hashable {
    let name: String
    let type: EntityType
}

enum EntityType: String, Sendable {
    case person
    case place
    case organization
    case other
}

import Foundation

/// Represents the user's emotional state for a journal entry
enum Mood: String, Codable, Sendable, CaseIterable {
    case veryHappy = "very_happy"
    case happy = "happy"
    case neutral = "neutral"
    case sad = "sad"
    case verySad = "very_sad"

    var emoji: String {
        switch self {
        case .veryHappy: return "😄"
        case .happy: return "🙂"
        case .neutral: return "😐"
        case .sad: return "😔"
        case .verySad: return "😢"
        }
    }

    var displayName: String {
        switch self {
        case .veryHappy: return "Very Happy"
        case .happy: return "Happy"
        case .neutral: return "Neutral"
        case .sad: return "Sad"
        case .verySad: return "Very Sad"
        }
    }

    var score: Int {
        switch self {
        case .veryHappy: return 5
        case .happy: return 4
        case .neutral: return 3
        case .sad: return 2
        case .verySad: return 1
        }
    }
}

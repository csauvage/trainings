import Foundation

/// Represents weather conditions for a journal entry
struct Weather: Codable, Sendable, Hashable {
    let temperature: Double
    let condition: WeatherCondition
    let humidity: Double?
    let windSpeed: Double?
    let timestamp: Date

    init(
        temperature: Double,
        condition: WeatherCondition,
        humidity: Double? = nil,
        windSpeed: Double? = nil,
        timestamp: Date = Date()
    ) {
        self.temperature = temperature
        self.condition = condition
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.timestamp = timestamp
    }

    var temperatureCelsius: Double {
        temperature
    }

    var temperatureFahrenheit: Double {
        (temperature * 9/5) + 32
    }

    var displayTemperature: String {
        String(format: "%.1f°C", temperatureCelsius)
    }
}

enum WeatherCondition: String, Codable, Sendable, CaseIterable {
    case clear = "clear"
    case cloudy = "cloudy"
    case partlyCloudy = "partly_cloudy"
    case rainy = "rainy"
    case stormy = "stormy"
    case snowy = "snowy"
    case foggy = "foggy"
    case windy = "windy"

    var emoji: String {
        switch self {
        case .clear: return "☀️"
        case .cloudy: return "☁️"
        case .partlyCloudy: return "⛅️"
        case .rainy: return "🌧️"
        case .stormy: return "⛈️"
        case .snowy: return "❄️"
        case .foggy: return "🌫️"
        case .windy: return "💨"
        }
    }

    var displayName: String {
        switch self {
        case .clear: return "Clear"
        case .cloudy: return "Cloudy"
        case .partlyCloudy: return "Partly Cloudy"
        case .rainy: return "Rainy"
        case .stormy: return "Stormy"
        case .snowy: return "Snowy"
        case .foggy: return "Foggy"
        case .windy: return "Windy"
        }
    }
}

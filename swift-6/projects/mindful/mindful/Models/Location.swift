import Foundation
import CoreLocation

/// Represents a geographic location for a journal entry
struct Location: Codable, Sendable, Hashable {
    let latitude: Double
    let longitude: Double
    let placeName: String?
    let city: String?
    let country: String?

    init(latitude: Double, longitude: Double, placeName: String? = nil, city: String? = nil, country: String? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.placeName = placeName
        self.city = city
        self.country = country
    }

    init(from coordinate: CLLocationCoordinate2D, placeName: String? = nil, city: String? = nil, country: String? = nil) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.placeName = placeName
        self.city = city
        self.country = country
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var displayName: String {
        if let placeName = placeName {
            return placeName
        }
        if let city = city {
            return city
        }
        if let country = country {
            return country
        }
        return "\(String(format: "%.4f", latitude)), \(String(format: "%.4f", longitude))"
    }
}

import CoreLocation
import Foundation
import MapKit
import SwiftData

extension CLLocationCoordinate2D: Codable {

  enum CodingKeys: String, CodingKey {
    case latitude
    case longitude
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
    let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
    self.init(latitude: latitude, longitude: longitude)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(latitude, forKey: .latitude)
    try container.encode(longitude, forKey: .longitude)
  }

}

extension CLLocation {
  convenience init(coordinate: CLLocationCoordinate2D) {
    self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
  }
}

@Model
final class AimlessDrive {
  var name: String = ""
  var startTime: Date = Date()
  var endTime: Date = Date()
  var route: [CLLocationCoordinate2D] = []

  init(
    name: String,
    startTime: Date,
    endTime: Date,
    route: [CLLocationCoordinate2D]
  ) {
    self.name = name
    self.startTime = startTime
    self.endTime = endTime
    self.route = route
  }

  func distanceTraveled() -> CLLocationDistance {
    guard !route.isEmpty else { return 0 }

    var distance: CLLocationDistance = 0
    var pointA = CLLocation(coordinate: route[0])

    for idx in 1..<route.count {
      let pointB = CLLocation(coordinate: route[idx])
      distance += pointA.distance(from: pointB)
      pointA = pointB
    }

    return distance
  }

  func formattedDistanceTraveled() -> String {
    let distanceFormatter = MKDistanceFormatter()
    distanceFormatter.unitStyle = .full
    return distanceFormatter.string(fromDistance: self.distanceTraveled())
  }
}

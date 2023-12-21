import CoreLocation
import Foundation
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

@Model
final class AimlessDrive {
  var name: String
  var startTime: Date
  var endTime: Date
  var route: [CLLocationCoordinate2D]

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
}

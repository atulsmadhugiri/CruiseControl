import MapKit
import SwiftData

@Model
final class LocationName {
  var coordinate: CLLocationCoordinate2D
  var name: String

  init(coordinate: CLLocationCoordinate2D, name: String) {
    self.coordinate = coordinate
    self.name = name
  }
}

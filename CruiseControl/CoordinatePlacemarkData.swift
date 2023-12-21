import CoreLocation
import SwiftData

@Model
final class CoordinatePlacemarkData {
  var coordinate: CLLocationCoordinate2D
  var placemarkData: PlacemarkData

  init(coordinate: CLLocationCoordinate2D, placemarkData: PlacemarkData) {
    self.coordinate = coordinate
    self.placemarkData = placemarkData
  }
}

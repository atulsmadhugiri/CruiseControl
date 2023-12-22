import CoreLocation
import SwiftData

@Model
final class CoordinatePlacemarkData {
  var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
  var placemarkData: PlacemarkData = PlacemarkData()

  init(coordinate: CLLocationCoordinate2D, placemarkData: PlacemarkData) {
    self.coordinate = coordinate
    self.placemarkData = placemarkData
  }
}

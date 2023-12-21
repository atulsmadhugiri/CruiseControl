import CoreLocation

struct PlacemarkData: Codable {
  var areasOfInterest: [String]?
  var locality: String?
  var subLocality: String?
  var administrativeArea: String?
  var subAdministrativeArea: String?
  var country: String?

  init(
    areasOfInterest: [String]? = nil,
    locality: String? = nil,
    subLocality: String? = nil,
    administrativeArea: String? = nil,
    subAdministrativeArea: String? = nil,
    country: String? = nil
  ) {
    self.areasOfInterest = areasOfInterest
    self.locality = locality
    self.subLocality = subLocality
    self.administrativeArea = administrativeArea
    self.subAdministrativeArea = subAdministrativeArea
    self.country = country
  }

  init(from placemark: CLPlacemark) {
    self.areasOfInterest = placemark.areasOfInterest
    self.locality = placemark.locality
    self.subLocality = placemark.locality
    self.administrativeArea = placemark.administrativeArea
    self.subAdministrativeArea = placemark.subAdministrativeArea
    self.country = placemark.country
  }
}

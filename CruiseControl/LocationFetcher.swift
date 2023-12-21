import CoreLocation

class LocationFetcher: NSObject, ObservableObject, CLLocationManagerDelegate {
  let locationManager = CLLocationManager()
  @Published var route: [CLLocationCoordinate2D] = []

  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    let coordinate = location.coordinate
    route.append(coordinate)
  }
}

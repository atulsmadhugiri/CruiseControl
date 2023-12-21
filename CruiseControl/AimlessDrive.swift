import CoreLocation
import Foundation
import SwiftData

@Model
final class AimlessDrive {
  var startTime: Date
  var endTime: Date
  var startLocation: CLLocationCoordinate2D
  var endLocation: CLLocationCoordinate2D
  var route: [CLLocationCoordinate2D]

  init(
    startTime: Date,
    endTime: Date,
    startLocation: CLLocationCoordinate2D,
    endLocation: CLLocationCoordinate2D,
    route: [CLLocationCoordinate2D]
  ) {
    self.startTime = startTime
    self.endTime = endTime
    self.startLocation = startLocation
    self.endLocation = endLocation
    self.route = route
  }
}

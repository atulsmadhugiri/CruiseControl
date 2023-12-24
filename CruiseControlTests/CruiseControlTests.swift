import CoreLocation
import XCTest

final class AimlessDrivePerformanceTests: XCTestCase {

  var aimlessDrive: AimlessDrive!

  override func setUp() {
    super.setUp()
    aimlessDrive = AimlessDrive(name: "TestDrive", startTime: Date(), endTime: Date(), route: [])
    for _ in 0..<1000 {
      let randomCoordinate = CLLocationCoordinate2D(
        latitude: CLLocationDegrees.random(in: -90...90),
        longitude: CLLocationDegrees.random(in: -180...180))
      aimlessDrive.route.append(randomCoordinate)
    }
  }

  var performanceOptions: XCTMeasureOptions {
    let options = XCTMeasureOptions()
    options.iterationCount = 10
    return options
  }

  func testDistanceTraveledPerformance() {
    measure(options: performanceOptions) {
      _ = self.aimlessDrive.distanceTraveled()
    }
  }
}

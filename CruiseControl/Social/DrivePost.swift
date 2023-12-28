import CloudKit
import CoreLocation

struct DrivePost {
  var recordID: CKRecord.ID?

  var name: String
  var description: String

  var startTime: Date
  var endtime: Date
  var route: [CLLocationCoordinate2D]
  var distanceTraveled: CLLocationDistance
}

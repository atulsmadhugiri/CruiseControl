import CloudKit
import CoreLocation

struct DrivePost {
  var recordID: CKRecord.ID?

  var name: String
  var description: String

  var startTime: Date
  var endTime: Date
  var route: [CLLocationCoordinate2D]
  var distanceTraveled: CLLocationDistance
}

extension DrivePost {
  func toCKRecord() -> CKRecord {
    let record = CKRecord(recordType: "DrivePostAlpha")

    record["name"] = name as CKRecordValue
    record["description"] = description as CKRecordValue

    record["startTime"] = startTime as CKRecordValue
    record["endTime"] = endTime as CKRecordValue
    record["distanceTraveled"] = distanceTraveled as CKRecordValue

    let routeData = route.map { ["latitude": $0.latitude, "longitude": $0.longitude] }
    record["route"] = routeData as CKRecordValue

    return record
  }
}

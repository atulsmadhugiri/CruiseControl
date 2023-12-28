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

    let routeStrings = route.map { "\($0.latitude),\($0.longitude)" }
    record["route"] = routeStrings as CKRecordValue

    return record
  }
}

extension DrivePost {
  init?(from record: CKRecord) {
    guard let name = record["name"] as? String,
      let description = record["description"] as? String,
      let startTime = record["startTime"] as? Date,
      let endTime = record["endTime"] as? Date,
      let distanceTraveled = record["distanceTraveled"] as? CLLocationDistance,
      let routeData = record["route"] as? [[String: Double]]
    else {
      return nil
    }

    let route = routeData.compactMap { data -> CLLocationCoordinate2D? in
      guard let latitude = data["latitude"], let longitude = data["longitude"] else { return nil }
      return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    self.init(
      name: name,
      description: description,
      startTime: startTime,
      endTime: endTime,
      route: route,
      distanceTraveled: distanceTraveled)
  }
}

extension DrivePost {
  func saveDrivePost() async {
    do {
      let record = self.toCKRecord()
      let publicDatabase = CKContainer.default().publicCloudDatabase
      let _ = try await publicDatabase.save(record)
      print("DrivePost saved successfully!")
    } catch {
      print("Error saving DrivePost: \(error.localizedDescription)")
    }
  }
}

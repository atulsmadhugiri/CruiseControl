import CloudKit
import CoreLocation

struct DrivePost: Identifiable {
  let id: UUID
  var recordID: CKRecord.ID?
  var creator: CKRecord.ID?

  var name: String
  var description: String

  var startTime: Date
  var endTime: Date
  var route: [CLLocationCoordinate2D]
  var distanceTraveled: CLLocationDistance

  init(
    name: String,
    description: String,
    startTime: Date,
    endTime: Date,
    route: [CLLocationCoordinate2D],
    distanceTraveled: CLLocationDistance,
    recordID: CKRecord.ID? = nil,
    creator: CKRecord.ID? = nil
  ) {
    self.id = UUID()
    self.name = name
    self.description = description
    self.startTime = startTime
    self.endTime = endTime
    self.route = route
    self.distanceTraveled = distanceTraveled
    self.recordID = recordID
    self.creator = creator
  }
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
      let routeStrings = record["route"] as? [String]
    else {
      return nil
    }

    let route = routeStrings.compactMap { string -> CLLocationCoordinate2D? in
      let components = string.split(separator: ",").compactMap { Double($0) }
      guard components.count == 2 else { return nil }
      return CLLocationCoordinate2D(latitude: components[0], longitude: components[1])
    }

    self.init(
      name: name,
      description: description,
      startTime: startTime,
      endTime: endTime,
      route: route,
      distanceTraveled: distanceTraveled,
      recordID: record.recordID)
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

extension DrivePost: Equatable {
  static func == (lhs: DrivePost, rhs: DrivePost) -> Bool {
    lhs.recordID == rhs.recordID
  }
}

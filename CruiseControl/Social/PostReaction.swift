import CloudKit
import Foundation

struct PostReaction {
  var drivePostRef: CKRecord.Reference
  var liked: Bool
  var recordID: CKRecord.ID?

  init(
    drivePostID: CKRecord.ID,
    liked: Bool,
    recordID: CKRecord.ID? = nil
  ) {
    self.drivePostRef = CKRecord.Reference(recordID: drivePostID, action: .none)
    self.liked = liked
    self.recordID = recordID
  }
}

extension PostReaction {
  func toCKRecord() -> CKRecord {
    let record =
      recordID != nil
      ? CKRecord(recordType: "PostReactionAlpha", recordID: recordID!)
      : CKRecord(recordType: "PostReactionAlpha")
    record["drivePostRef"] = drivePostRef
    record["liked"] = liked
    return record
  }
}

extension PostReaction {
  init?(from record: CKRecord) {
    guard let drivePostRef = record["drivePostRef"] as? CKRecord.Reference,
      let liked = record["liked"] as? Bool
    else {
      return nil
    }

    self.init(
      drivePostID: drivePostRef.recordID,
      liked: liked,
      recordID: record.recordID)
  }
}

extension PostReaction {
  func saveReaction() async {
    do {
      let record = self.toCKRecord()
      let publicDB = CKContainer.default().publicCloudDatabase
      let _ = try await publicDB.save(record)
      print("PostReaction saved successfully!")
    } catch {
      print("Error saving PostReaction: \(error.localizedDescription)")
    }
  }
}

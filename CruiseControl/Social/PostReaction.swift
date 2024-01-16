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

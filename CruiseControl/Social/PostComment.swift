import CloudKit
import Foundation

struct PostComment {
  var drivePostRef: CKRecord.Reference
  var content: String
  var recordID: CKRecord.ID?
  var creator: CKRecord.ID?

  init(
    drivePostID: CKRecord.ID,
    content: String,
    recordID: CKRecord.ID? = nil,
    creator: CKRecord.ID? = nil
  ) {
    self.drivePostRef = CKRecord.Reference(recordID: drivePostID, action: .none)
    self.content = content
    self.recordID = recordID
    self.creator = creator
  }
}

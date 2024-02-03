import CloudKit
import Foundation

struct PostComment: Identifiable {
  let id: UUID
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
    self.id = UUID()
    self.drivePostRef = CKRecord.Reference(recordID: drivePostID, action: .none)
    self.content = content
    self.recordID = recordID
    self.creator = creator
  }
}

extension PostComment {
  func toCKRecord() -> CKRecord {
    let record =
      recordID != nil
      ? CKRecord(recordType: "PostCommentAlpha", recordID: recordID!)
      : CKRecord(recordType: "PostCommentAlpha")
    record["drivePostRef"] = drivePostRef
    record["content"] = content
    return record
  }
}

extension PostComment {
  init?(from record: CKRecord) {
    guard let drivePostRef = record["drivePostRef"] as? CKRecord.Reference,
      let content = record["content"] as? String
    else {
      return nil
    }

    self.init(
      drivePostID: drivePostRef.recordID,
      content: content,
      recordID: record.recordID,
      creator: record.creatorUserRecordID)
  }
}

extension PostComment {
  func saveComment() async {
    do {
      let record = self.toCKRecord()
      let publicDB = CKContainer.default().publicCloudDatabase
      let _ = try await publicDB.save(record)
      print("PostComment saved successfully!")
    } catch {
      print("Error saving PostComment: \(error.localizedDescription)")
    }
  }
}

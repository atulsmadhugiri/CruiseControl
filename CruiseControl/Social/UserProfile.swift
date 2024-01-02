import CloudKit

struct UserProfile {
  var firstName: String
  var lastName: String
  var biography: String
  var profilePicture: URL?

  init(
    firstName: String,
    lastName: String,
    biography: String,
    profilePicture: URL? = nil
  ) {
    self.firstName = firstName
    self.lastName = lastName
    self.biography = biography
    self.profilePicture = profilePicture
  }
}

extension UserProfile {
  func toCKRecord() -> CKRecord {
    let record = CKRecord(recordType: "UserProfileAlpha")

    record["firstName"] = firstName as CKRecordValue
    record["lastName"] = lastName as CKRecordValue
    record["biography"] = biography as CKRecordValue

    return record
  }
}

func potentiallyGetExistingUserProfileRecord() async -> CKRecord.ID? {
  do {
    let userRecordID = try await CKContainer.default().userRecordID()
    let publicDatabase = CKContainer.default().publicCloudDatabase
    let reference = CKRecord.Reference(recordID: userRecordID, action: .none)
    let predicate = NSPredicate(format: "creatorUserRecordID == %@", reference)
    let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)

    let query = CKQuery(recordType: "UserProfileAlpha", predicate: predicate)
    query.sortDescriptors = [sortDescriptor]

    let (matchResults, _) = try await publicDatabase.records(matching: query)
    guard let (firstResultID, _) = matchResults.first else { return nil }
    return firstResultID
  } catch {
    print("Error potentially fetching UserProfile: \(error.localizedDescription)")
    return nil
  }
}

extension UserProfile {
  func saveUserProfile() async {
    do {
      let record = self.toCKRecord()
      let publicDatabase = CKContainer.default().publicCloudDatabase
      let _ = try await publicDatabase.save(record)
      print("UserProfile saved successfully!")
    } catch {
      print("Error saving UserProfile: \(error.localizedDescription)")
    }
  }
}

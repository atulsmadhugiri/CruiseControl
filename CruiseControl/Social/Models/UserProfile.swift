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
  init?(from record: CKRecord) {
    guard let firstName = record["firstName"] as? String,
      let lastName = record["lastName"] as? String,
      let biography = record["biography"] as? String,
      let profilePicture = record["profilePicture"] as? CKAsset
    else {
      return nil
    }

    self.init(
      firstName: firstName,
      lastName: lastName,
      biography: biography
    )
  }
}

extension UserProfile {
  func toCKRecord() -> CKRecord {
    let record = CKRecord(recordType: "UserProfileAlpha")

    record["firstName"] = firstName as CKRecordValue
    record["lastName"] = lastName as CKRecordValue
    record["biography"] = biography as CKRecordValue

    if let profilePicture = profilePicture {
      record["profilePicture"] = CKAsset(fileURL: profilePicture)
    }

    return record
  }
}

func potentiallyGetUserProfileRecord(userRecordID: CKRecord.ID) async -> CKRecord? {
  do {
    let publicDatabase = CKContainer.default().publicCloudDatabase
    let reference = CKRecord.Reference(recordID: userRecordID, action: .none)
    let predicate = NSPredicate(format: "creatorUserRecordID == %@", reference)
    let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)

    let query = CKQuery(recordType: "UserProfileAlpha", predicate: predicate)
    query.sortDescriptors = [sortDescriptor]

    let (matchResults, _) = try await publicDatabase.records(matching: query)
    guard let (_, matchedRecord) = matchResults.first else { return nil }

    switch matchedRecord {
    case .success(let record):
      return record
    case .failure(_):
      return nil
    }
  } catch {
    print("Error potentially fetching UserProfile: \(error.localizedDescription)")
    return nil
  }
}

func potentiallyGetCurrentUserProfileRecord() async -> CKRecord? {
  do {
    let currentUserRecordID = try await CKContainer.default().userRecordID()
    return await potentiallyGetUserProfileRecord(userRecordID: currentUserRecordID)
  } catch {
    print("Error potentially fetching UserProfile: \(error.localizedDescription)")
    return nil
  }
}

extension UserProfile {
  func saveUserProfile() async {
    do {

      if let existingRecord = await potentiallyGetCurrentUserProfileRecord() {
        existingRecord["firstName"] = firstName as CKRecordValue
        existingRecord["lastName"] = lastName as CKRecordValue
        existingRecord["biography"] = biography as CKRecordValue
        if let profilePicture = profilePicture {
          existingRecord["profilePicture"] = CKAsset(fileURL: profilePicture)
        }
        let publicDatabase = CKContainer.default().publicCloudDatabase
        let _ = try await publicDatabase.save(existingRecord)

      } else {
        let record = self.toCKRecord()
        let publicDatabase = CKContainer.default().publicCloudDatabase
        let _ = try await publicDatabase.save(record)
      }
      print("UserProfile saved successfully!")
    } catch {
      print("Error saving UserProfile: \(error.localizedDescription)")
    }
  }
}

func fetchUserProfiles() async -> [UserProfile] {
  let publicDB = CKContainer.default().publicCloudDatabase
  let query = CKQuery(
    recordType: "UserProfileAlpha",
    predicate: NSPredicate(value: true)
  )

  do {
    let (matchResults, _) = try await publicDB.records(matching: query)
    let fetchedUserProfiles: [UserProfile] = try matchResults.compactMap {
      (_, recordResult) in
      let record = try recordResult.get()
      return UserProfile(from: record)
    }
    return fetchedUserProfiles
  } catch {
    print("Error fetching record: \(error.localizedDescription)")
    return []
  }
}

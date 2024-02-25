import CloudKit

class SocialFeedViewModel: ObservableObject {
  @Published var drivePosts: [DrivePost] = []
  @Published var currentUserID: CKRecord.ID? = nil

  @MainActor
  func fetchDrivePosts() async {
    let publicDB = CKContainer.default().publicCloudDatabase
    let query = CKQuery(recordType: "DrivePostAlpha", predicate: NSPredicate(value: true))
    let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
    query.sortDescriptors = [sortDescriptor]

    do {
      let (matchResults, _) = try await publicDB.records(matching: query)
      var newPosts: [DrivePost] = []
      for (_, recordResult) in matchResults {
        switch recordResult {
        case .success(let record):
          if let post = DrivePost(from: record) {
            newPosts.append(post)
          }
        case .failure(let error):
          print("Error fetching record: \(error.localizedDescription)")
        }
      }
      if !newPosts.elementsEqual(drivePosts) {
        drivePosts = newPosts
      }
    } catch {
      print("Error fetching records: \(error.localizedDescription)")
    }
  }

  @MainActor
  func fetchCurrentUserID() async {
    let currentUserRecord: CKRecord? = await potentiallyGetCurrentUserProfileRecord()
    self.currentUserID = currentUserRecord?.creatorUserRecordID
  }

}
